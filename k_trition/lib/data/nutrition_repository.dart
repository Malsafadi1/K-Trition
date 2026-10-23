import 'package:drift/drift.dart';

import 'database.dart';
import 'models.dart';
export 'database.dart' show Food, Meal, MealItem, WaterEntry, Goal;
export 'models.dart';

/// Data-only API: no Firebase, sign-in, or UI dependencies.
class NutritionRepository {
  NutritionRepository(this.database);
  final AppDatabase database;
  static Future<NutritionRepository> open({QueryExecutor? executor}) async {
    final db = AppDatabase(executor);
    try {
      await db.initialize();
      return NutritionRepository(db);
    } catch (_) {
      await db.close();
      rethrow;
    }
  }

  Future<void> close() => database.close();
  SimpleSelectStatement<Foods, Food> _foodQuery(
    String query,
    String? category,
    int limit,
    int offset,
    bool commonOnly,
  ) {
    if (limit < 1 || limit > 100 || offset < 0) {
      throw ArgumentError('Limit must be 1–100; offset cannot be negative');
    }
    final q = database.select(database.foods)
      ..where((f) => f.isListed.equals(true));
    if (commonOnly) {
      q.where((f) => f.isCommon.equals(true));
    }
    if (query.trim().isNotEmpty) {
      q.where((f) => f.name.contains(query.trim()));
    }
    if (category != null) {
      q.where((f) => f.category.equals(category));
    }
    q.orderBy([
      (f) => OrderingTerm(expression: f.name.collate(Collate.noCase)),
      (f) => OrderingTerm.asc(f.fdcId),
    ]);
    q.limit(limit, offset: offset);
    return q;
  }

  Future<List<Food>> searchFoods({
    String query = '',
    String? category,
    int limit = 25,
    int offset = 0,
    bool commonOnly = false,
  }) => _foodQuery(query, category, limit, offset, commonOnly).get();
  Stream<List<Food>> watchFoods({
    String query = '',
    String? category,
    int limit = 25,
    int offset = 0,
    bool commonOnly = false,
  }) => _foodQuery(query, category, limit, offset, commonOnly).watch();
  Future<List<String>> getCategories() async =>
      (await database
              .customSelect(
                'SELECT DISTINCT category FROM foods WHERE is_listed=1 ORDER BY category',
              )
              .get())
          .map((r) => r.read<String>('category'))
          .toList();
  Future<Food> getFood(int id) => (database.select(
    database.foods,
  )..where((f) => f.fdcId.equals(id))).getSingle();
  NutritionTotals calculate(Food f, double grams) {
    positive(grams, 'Grams');
    return NutritionTotals(
      calories: f.kcalPerG * grams,
      protein: f.proteinPerG * grams,
      carbs: f.carbsPerG * grams,
      fat: f.fatPerG * grams,
    );
  }

  Future<int> saveMeal({
    int? id,
    required String name,
    required String mealType,
    required DateTime loggedAt,
    required List<MealPortion> portions,
  }) async {
    if (name.trim().isEmpty ||
        name.length > 200 ||
        !['Breakfast', 'Lunch', 'Dinner', 'Snack'].contains(mealType) ||
        portions.isEmpty ||
        portions.length > 50) {
      throw ArgumentError('Provide a name, meal type and 1–50 food portions');
    }
    return database.transaction(() async {
      final snapshots = <int, MealItem>{};
      if (id != null) {
        for (final i in await getMealItems(id)) {
          snapshots.putIfAbsent(i.foodId, () => i);
        }
      }
      final resolved = await Future.wait(
        portions.map((p) => getFood(p.foodId)),
      );
      if (resolved.any((f) => !f.isListed && !snapshots.containsKey(f.fdcId))) {
        throw ArgumentError('This food is no longer available for new meals');
      }
      int mealId;
      if (id == null) {
        mealId = await database
            .into(database.meals)
            .insert(
              MealsCompanion.insert(
                name: name.trim(),
                mealType: mealType,
                loggedAt: loggedAt.millisecondsSinceEpoch,
              ),
            );
      } else {
        final n =
            await (database.update(
              database.meals,
            )..where((m) => m.id.equals(id))).write(
              MealsCompanion(
                name: Value(name.trim()),
                mealType: Value(mealType),
                loggedAt: Value(loggedAt.millisecondsSinceEpoch),
              ),
            );
        if (n == 0) throw StateError('Meal not found');
        mealId = id;
        await (database.delete(
          database.mealItems,
        )..where((i) => i.mealId.equals(id))).go();
      }
      for (var i = 0; i < portions.length; i++) {
        final f = resolved[i], old = snapshots[resolved[i].fdcId];
        await database
            .into(database.mealItems)
            .insert(
              MealItemsCompanion.insert(
                mealId: mealId,
                foodId: f.fdcId,
                foodName: old?.foodName ?? f.name,
                grams: portions[i].grams,
                kcalPerG: old?.kcalPerG ?? f.kcalPerG,
                proteinPerG: old?.proteinPerG ?? f.proteinPerG,
                carbsPerG: old?.carbsPerG ?? f.carbsPerG,
                fatPerG: old?.fatPerG ?? f.fatPerG,
              ),
            );
      }
      return mealId;
    });
  }

  Future<int> deleteMeal(int id) =>
      (database.delete(database.meals)..where((m) => m.id.equals(id))).go();
  SimpleSelectStatement<Meals, Meal> _mealsQuery(DateTime day) =>
      database.select(database.meals)
        ..where(
          (m) =>
              m.loggedAt.isBiggerOrEqualValue(
                localDay(day).millisecondsSinceEpoch,
              ) &
              m.loggedAt.isSmallerThanValue(
                nextDay(day).millisecondsSinceEpoch,
              ),
        )
        ..orderBy([
          (m) => OrderingTerm.desc(m.loggedAt),
          (m) => OrderingTerm.desc(m.id),
        ]);
  Future<List<Meal>> mealsForDay(DateTime day) => _mealsQuery(day).get();
  Stream<List<Meal>> watchMeals(DateTime day) => _mealsQuery(day).watch();
  Future<List<MealItem>> getMealItems(int id) => (database.select(
    database.mealItems,
  )..where((i) => i.mealId.equals(id))).get();
  Future<int> saveWater({
    int? id,
    required double ounces,
    required DateTime loggedAt,
  }) async {
    positive(ounces, 'Water ounces');
    if (id == null) {
      return database
          .into(database.waterEntries)
          .insert(
            WaterEntriesCompanion.insert(
              ounces: ounces,
              loggedAt: loggedAt.millisecondsSinceEpoch,
            ),
          );
    }
    final n =
        await (database.update(
          database.waterEntries,
        )..where((w) => w.id.equals(id))).write(
          WaterEntriesCompanion(
            ounces: Value(ounces),
            loggedAt: Value(loggedAt.millisecondsSinceEpoch),
          ),
        );
    if (n == 0) throw StateError('Water entry not found');
    return id;
  }

  Future<int> deleteWater(int id) => (database.delete(
    database.waterEntries,
  )..where((w) => w.id.equals(id))).go();
  SimpleSelectStatement<WaterEntries, WaterEntry> _waterQuery(DateTime day) =>
      database.select(database.waterEntries)
        ..where(
          (w) =>
              w.loggedAt.isBiggerOrEqualValue(
                localDay(day).millisecondsSinceEpoch,
              ) &
              w.loggedAt.isSmallerThanValue(
                nextDay(day).millisecondsSinceEpoch,
              ),
        )
        ..orderBy([
          (w) => OrderingTerm.desc(w.loggedAt),
          (w) => OrderingTerm.desc(w.id),
        ]);
  Future<List<WaterEntry>> waterForDay(DateTime day) => _waterQuery(day).get();
  Stream<List<WaterEntry>> watchWater(DateTime day) => _waterQuery(day).watch();
  Future<void> setGoals({
    required double calories,
    required double waterOunces,
    required DateTime effectiveDate,
  }) async {
    positive(calories, 'Calorie goal');
    positive(waterOunces, 'Water goal');
    await database
        .into(database.goals)
        .insertOnConflictUpdate(
          GoalsCompanion.insert(
            effectiveDate: dayKey(effectiveDate),
            calories: calories,
            waterOunces: waterOunces,
          ),
        );
  }

  Future<Goal?> goalsForDay(DateTime day) =>
      (database.select(database.goals)
            ..where((g) => g.effectiveDate.isSmallerOrEqualValue(dayKey(day)))
            ..orderBy([(g) => OrderingTerm.desc(g.effectiveDate)])
            ..limit(1))
          .getSingleOrNull();
  Selectable<QueryRow> _progressQuery(DateTime day) => database.customSelect(
    '''
SELECT COALESCE(SUM(i.grams*i.kcal_per_g),0.0) AS calories,
 COALESCE(SUM(i.grams*i.protein_per_g),0.0) AS protein,
 COALESCE(SUM(i.grams*i.carbs_per_g),0.0) AS carbs,
 COALESCE(SUM(i.grams*i.fat_per_g),0.0) AS fat,
 (SELECT COALESCE(SUM(ounces),0.0) FROM water_entries WHERE logged_at>=?1 AND logged_at<?2) AS water,
 (SELECT calories FROM goals WHERE effective_date<=?3 ORDER BY effective_date DESC LIMIT 1) AS calorie_goal,
 (SELECT water_ounces FROM goals WHERE effective_date<=?3 ORDER BY effective_date DESC LIMIT 1) AS water_goal
FROM meal_items i JOIN meals m ON m.id=i.meal_id WHERE m.logged_at>=?1 AND m.logged_at<?2
''',
    variables: [
      Variable<int>(localDay(day).millisecondsSinceEpoch),
      Variable<int>(nextDay(day).millisecondsSinceEpoch),
      Variable<String>(dayKey(day)),
    ],
    readsFrom: {
      database.meals,
      database.mealItems,
      database.waterEntries,
      database.goals,
    },
  );
  DailyProgress _progress(DateTime day, QueryRow row) => DailyProgress(
    day: localDay(day),
    nutrition: NutritionTotals(
      calories: row.read<double>('calories'),
      protein: row.read<double>('protein'),
      carbs: row.read<double>('carbs'),
      fat: row.read<double>('fat'),
    ),
    waterOunces: row.read<double>('water'),
    calorieGoal: row.readNullable<double>('calorie_goal'),
    waterGoalOunces: row.readNullable<double>('water_goal'),
  );
  Future<DailyProgress> progressForDay(DateTime day) async =>
      _progress(day, await _progressQuery(day).getSingle());
  Stream<DailyProgress> watchDailyProgress(DateTime day) =>
      _progressQuery(day).watchSingle().map((r) => _progress(day, r));

  /// Calendar-day history for day/week/month UI; no UI controls are added here.
  Future<List<DailyProgress>> progressForRange(
    DateTime start,
    DateTime endExclusive,
  ) async {
    final first = localDay(start), last = localDay(endExclusive);
    if (last.isBefore(first) || last.difference(first).inDays > 366) {
      throw ArgumentError('Range must be 0–366 days');
    }
    final result = <DailyProgress>[];
    for (var d = first; d.isBefore(last); d = nextDay(d)) {
      result.add(await progressForDay(d));
    }
    return result;
  }
}
