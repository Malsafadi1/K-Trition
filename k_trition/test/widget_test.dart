import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_trition/app/k_trition_app.dart';
import 'package:k_trition/data/nutrition_repository.dart';
import 'package:k_trition/features/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('home starts with empty logs and displays the requested units', (
    tester,
  ) async {
    await tester.pumpWidget(const KTritionApp());

    expect(find.text('K-Trition'), findsOneWidget);
    expect(find.text('Calories'), findsOneWidget);
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

  testWidgets('food and water logging update daily totals', (tester) async {
    await tester.pumpWidget(const KTritionApp());

    await tester.enterText(find.byType(TextField).at(0), 'Apple');
    await tester.enterText(find.byType(TextField).at(1), '150');
    await tester.enterText(find.byType(TextField).at(2), '100');
    await tester.ensureVisible(find.text('Add Food'));
    await tester.tap(find.text('Add Food'));
    await tester.pumpAndSettle();

    expect(find.text('Apple - 150 g'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText && widget.text.toPlainText().contains('100'),
      ),
      findsOneWidget,
    );

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

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Apple - 150 g'), findsOneWidget);
    expect(find.text('16 Oz'), findsWidgets);
    expect(find.text('100 Cal'), findsWidgets);
  });

  testWidgets('daily goals can be edited and reject non-positive values', (
    tester,
  ) async {
    await tester.pumpWidget(const KTritionApp());
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
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('/ 2,500 Cal'), findsOneWidget);
    expect(find.text('/ 80 Oz'), findsOneWidget);
  });

  testWidgets('history starts empty and switches between date ranges', (
    tester,
  ) async {
    await tester.pumpWidget(const KTritionApp());
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

  testWidgets('settings opens help and changes the saved app theme', (
    tester,
  ) async {
    await tester.pumpWidget(const KTritionApp());
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.widgetWithText(ListTile, 'Help & Support'));
    await tester.pumpAndSettle();
    expect(find.text('Frequently asked questions'), findsOneWidget);
    expect(find.text('Contact Support'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('dark_mode'), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const KTritionApp());
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('settings navigates to the meal history screen', (tester) async {
    final pendingRepository = Completer<NutritionRepository>();
    await tester.pumpWidget(_settingsHarness(() => pendingRepository.future));
    await tester.tap(find.widgetWithText(ListTile, 'Meal History'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(
      find.descendant(
        of: find.byType(AppBar).last,
        matching: find.text('Meal History'),
      ),
      findsOneWidget,
    );
  });
}

Widget _settingsHarness(
  Future<NutritionRepository> Function() repositoryLoader,
) => MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF28C28)),
    useMaterial3: true,
  ),
  home: SettingsPage(
    isDarkMode: false,
    onDarkModeChanged: (_) async {},
    repositoryLoader: repositoryLoader,
  ),
);

Finder _homeScroll() => find
    .byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    )
    .first;
