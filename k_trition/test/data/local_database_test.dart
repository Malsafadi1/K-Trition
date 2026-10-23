import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_trition/data/nutrition_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'Core-food catalog, common shortlist, search and verified nutrition',
    () async {
      final repo = await NutritionRepository.open(
        executor: NativeDatabase.memory(),
      );
      try {
        final all = await repo.database.select(repo.database.foods).get();
        expect(all.length, 5084);
        final foods = await repo.searchFoods(limit: 100, commonOnly: true);
        expect(foods.length, 44);
        expect(foods.map((f) => f.name.toLowerCase()).toSet().length, 44);
        expect(
          foods.any(
            (f) => RegExp(
              r'baby|alcohol|beer|wine',
              caseSensitive: false,
            ).hasMatch(f.name),
          ),
          isFalse,
        );
        expect(
          (await repo.searchFoods(
            query: 'sirloin',
            commonOnly: true,
          )).single.name,
          'Sirloin steak (grilled)',
        );
        expect(
          await repo.getCategories(),
          containsAll([
            'Fruits and Fruit Juices',
            'Beef Products',
            'Vegetables and Vegetable Products',
          ]),
        );
        final apple = (await repo.searchFoods(query: 'apple'))
            .firstWhere((f) => f.name == 'Apple');
        final n = repo.calculate(apple, 150);
        expect(n.calories, closeTo(78, 1e-8));
        expect(n.protein, closeTo(0.39, 1e-8));
        expect(n.carbs, closeTo(20.715, 1e-8));
        expect(n.fat, closeTo(.255, 1e-8));
        expect(
          (await repo.searchFoods(
            category: 'Fruits and Fruit Juices',
            limit: 100,
          )).length,
          100,
        );
        expect(
          (await repo.searchFoods(
            limit: 10,
            offset: 10,
            commonOnly: true,
          )).first.fdcId,
          isNot(foods.first.fdcId),
        );
      } finally {
        await repo.close();
      }
    },
  );
  test(
    'Atomic meal edits, snapshots, goals, deletion and restart persistence',
    () async {
      final dir = await Directory.systemTemp.createTemp('ktrition_db_');
      final file = File('${dir.path}/database.sqlite');
      var repo = await NutritionRepository.open(executor: NativeDatabase(file));
      final day = DateTime(2026, 10, 23, 12), past = DateTime(2026, 10, 22, 12);
      try {
        final f = await repo.getFood(171688);
        final id = await repo.saveMeal(
          name: 'Lunch',
          mealType: 'Lunch',
          loggedAt: day,
          portions: [
            MealPortion(foodId: f.fdcId, grams: 100),
            MealPortion(foodId: f.fdcId, grams: 50),
          ],
        );
        await repo.saveMeal(
          name: 'Old snack',
          mealType: 'Snack',
          loggedAt: past,
          portions: [MealPortion(foodId: f.fdcId, grams: 50)],
        );
        final water = await repo.saveWater(ounces: 8, loggedAt: day);
        await repo.setGoals(
          calories: 2000,
          waterOunces: 64,
          effectiveDate: past,
        );
        await repo.setGoals(
          calories: 2200,
          waterOunces: 72,
          effectiveDate: day,
        );
        expect(
          (await repo.progressForDay(day)).nutrition.calories,
          closeTo(78, 1e-8),
        );
        expect((await repo.progressForDay(past)).calorieGoal, 2000);
        expect(
          (await repo.progressForDay(DateTime(2026, 10, 21))).calorieGoal,
          isNull,
        );
        await expectLater(
          repo.saveMeal(
            id: id,
            name: 'Bad edit',
            mealType: 'Lunch',
            loggedAt: day,
            portions: [MealPortion(foodId: -1, grams: 100)],
          ),
          throwsA(isA<StateError>()),
        );
        expect((await repo.getMealItems(id)).length, 2);
        await repo.database.customStatement(
          'UPDATE foods SET kcal_per_g=99 WHERE fdc_id=?',
          [f.fdcId],
        );
        await repo.saveMeal(
          id: id,
          name: 'Edited lunch',
          mealType: 'Lunch',
          loggedAt: day,
          portions: [MealPortion(foodId: f.fdcId, grams: 200)],
        );
        expect(
          (await repo.progressForDay(day)).nutrition.calories,
          closeTo(104, 1e-8),
        );
        await repo.saveWater(id: water, ounces: 12, loggedAt: day);
        await repo.close();
        repo = await NutritionRepository.open(executor: NativeDatabase(file));
        expect((await repo.mealsForDay(day)).single.name, 'Edited lunch');
        expect((await repo.progressForDay(day)).waterOunces, 12);
        expect((await repo.progressForDay(day)).calorieGoal, 2200);
        await repo.deleteMeal(id);
        expect(await repo.getMealItems(id), isEmpty);
        await repo.deleteWater(water);
        expect((await repo.progressForDay(day)).waterOunces, 0);
        expect((await repo.progressForDay(day)).nutrition.calories, 0);
        expect(
          (await repo.progressForRange(past, DateTime(2026, 10, 24))).length,
          2,
        );
      } finally {
        await repo.close();
        await dir.delete(recursive: true);
      }
    },
  );
  test('Live progress emits when entries and goals change', () async {
    final repo = await NutritionRepository.open(
      executor: NativeDatabase.memory(),
    );
    final day = DateTime(2026, 10, 23);
    final ready = Completer<void>(), changed = Completer<void>();
    final sub = repo.watchDailyProgress(day).listen((p) {
      if (!ready.isCompleted) ready.complete();
      if (p.waterOunces == 16 &&
          p.waterGoalOunces == 64 &&
          !changed.isCompleted) {
        changed.complete();
      }
    });
    try {
      await ready.future.timeout(const Duration(seconds: 5));
      await repo.saveWater(ounces: 16, loggedAt: day);
      await repo.setGoals(calories: 2000, waterOunces: 64, effectiveDate: day);
      await changed.future.timeout(const Duration(seconds: 5));
    } finally {
      await sub.cancel();
      await repo.close();
    }
  });
  test('Local calendar boundaries and invalid input', () async {
    final repo = await NutritionRepository.open(
      executor: NativeDatabase.memory(),
    );
    try {
      final day = DateTime(2026, 3, 8);
      await repo.saveWater(ounces: 8, loggedAt: day);
      await repo.saveWater(
        ounces: 16,
        loggedAt: DateTime(2026, 3, 8, 23, 59, 59),
      );
      await repo.saveWater(ounces: 32, loggedAt: DateTime(2026, 3, 9));
      expect((await repo.progressForDay(day)).waterOunces, 24);
      expect(
        () => MealPortion(foodId: 1, grams: double.nan),
        throwsArgumentError,
      );
      await expectLater(
        repo.saveWater(ounces: 0, loggedAt: day),
        throwsArgumentError,
      );
      await expectLater(
        repo.saveWater(id: 999, ounces: 1, loggedAt: day),
        throwsStateError,
      );
      expect(nextDay(DateTime(2026, 12, 31)), DateTime(2027, 1, 1));
    } finally {
      await repo.close();
    }
  });
}
