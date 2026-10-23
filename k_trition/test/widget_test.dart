import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:k_trition/app/k_trition_app.dart';

void main() {
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
    expect(find.text('100 kcal'), findsWidgets);
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
}

Finder _homeScroll() => find
    .byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    )
    .first;
