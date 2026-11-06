import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_trition/app/k_trition_app.dart';
import 'package:k_trition/data/nutrition_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('home starts with empty logs and displays the requested units', (
    tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text('K-Trition'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Amount (Oz)'),
      120,
      scrollable: _homeScroll(),
    );
    expect(find.text('Amount (Oz)'), findsOneWidget);
    expect(find.text('Serving size (g)'), findsOneWidget);
    expect(find.text('8 Oz'), findsOneWidget);
    expect(find.text('16 Oz'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('No food logged yet. Add your first meal above.'),
      200,
      scrollable: _homeScroll(),
    );
    expect(
      find.text('No food logged yet. Add your first meal above.'),
      findsOneWidget,
    );
  });

  testWidgets('simple food choices scroll and show their nutrition baseline', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.enterText(find.byType(TextField).at(0), 'ch');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    final results = find.byType(ListView).last;
    await tester.drag(results, const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.enterText(find.byType(TextField).at(0), 'Apple');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: find.byType(ListTile), matching: find.text('Apple')),
      findsOneWidget,
    );
    expect(find.textContaining('Baseline: raw'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('category browsing works without a search term', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Proteins').last);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(ListTile),
        matching: find.text('Beef steak'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byType(ListTile), matching: find.text('Apple')),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('food and water logging update daily totals', (tester) async {
    final repository = await _pumpApp(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Apple');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apple').last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).at(2)).controller!.text,
      '52',
    );
    await tester.enterText(find.byType(TextField).at(1), '150');
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).at(2)).controller!.text,
      '78',
    );
    await tester.drag(_homeScroll(), const Offset(0, -150));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Food'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Apple - 150 g'),
      200,
      scrollable: _homeScroll(),
    );
    expect(find.text('Apple - 150 g'), findsOneWidget);
    expect(find.text('78 Cal'), findsWidgets);
    await tester.runAsync(() async {
      final meals = await repository.mealsForDay(DateTime.now());
      expect(meals, hasLength(1));
      expect(
        (await repository.progressForDay(DateTime.now())).nutrition.calories,
        closeTo(78, 1e-8),
      );
    });

    await tester.scrollUntilVisible(
      find.text('16 Oz'),
      250,
      scrollable: _homeScroll(),
    );
    await tester.tap(find.text('16 Oz'));
    await tester.drag(find.byType(ListView).first, const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add Water'));
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      expect(await repository.waterForDay(DateTime.now()), hasLength(1));
    });

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Apple - 150 g'), findsOneWidget);
    expect(find.text('16 Oz'), findsWidgets);
    expect(find.text('78 Cal'), findsWidgets);
  });

  testWidgets('food form can add multiple items and show their macros', (
    tester,
  ) async {
    final repository = await _pumpApp(tester);

    expect(find.text('Add another item'), findsNothing);
    await tester.enterText(find.byType(TextField).at(0), 'Apple');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Apple').last);
    await tester.pumpAndSettle();

    expect(find.text('Protein'), findsWidgets);
    expect(find.text('Carbs'), findsWidgets);
    expect(find.text('Fat'), findsWidgets);
    expect(find.text('Add another item'), findsOneWidget);
    await tester.ensureVisible(find.text('Add another item'));
    await tester.tap(find.text('Add another item'));
    await tester.pumpAndSettle();
    expect(find.text('Apple · 100 g'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'Banana');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Save Meal'));
    await tester.tap(find.text('Save Meal'));
    await tester.pumpAndSettle();

    await tester.runAsync(() async {
      final meals = await repository.mealsForDay(DateTime.now());
      expect(meals, hasLength(1));
      final items = await repository.getMealItems(meals.single.id);
      expect(items.map((item) => item.foodName), ['Apple', 'Banana']);
    });
  });

  testWidgets('daily goals can be edited and reject non-positive values', (
    tester,
  ) async {
    final repository = await _pumpApp(tester);
    await tester.tap(find.text('Edit Goals'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '0');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      find.text('Calorie goal must be a whole number greater than zero.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextFormField).at(0), '2500');
    await tester.enterText(find.byType(TextFormField).at(1), '80');
    await tester.enterText(find.byType(TextFormField).at(2), '140');
    await tester.enterText(find.byType(TextFormField).at(3), '250');
    await tester.enterText(find.byType(TextFormField).at(4), '70');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('/ 2,500 Cal'), findsOneWidget);
    expect(find.text('/ 80 Oz'), findsOneWidget);
    expect(find.text('0 / 140 g'), findsOneWidget);
    expect(find.text('0 / 250 g'), findsOneWidget);
    expect(find.text('0 / 70 g'), findsOneWidget);
    final goal = await tester.runAsync(
      () => repository.goalsForDay(DateTime.now()),
    );
    expect(goal?.calories, 2500);
    expect(goal?.proteinGrams, 140);
    expect(goal?.carbsGrams, 250);
    expect(goal?.fatGrams, 70);
  });

  testWidgets('history starts empty and switches between date ranges', (
    tester,
  ) async {
    await _pumpApp(tester);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('History'), findsWidgets);
    expect(find.text('Day'), findsOneWidget);
    expect(find.text('Week'), findsOneWidget);
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('No food logged for this period.'), findsOneWidget);
    expect(find.text('No water logged for this period.'), findsOneWidget);

    await tester.tap(find.text('Month'));
    await tester.pumpAndSettle();
    expect(find.text('No food logged for this period.'), findsOneWidget);
  });
}

Future<NutritionRepository> _pumpApp(WidgetTester tester) async {
  final repository = await tester.runAsync(
    () => NutritionRepository.open(executor: NativeDatabase.memory()),
  );
  if (repository == null) {
    throw StateError('The widget test repository did not initialize.');
  }
  addTearDown(repository.close);
  await tester.pumpWidget(KTritionApp(repository: repository));
  await tester.pumpAndSettle();
  return repository;
}

Finder _homeScroll() => find
    .byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    )
    .first;
