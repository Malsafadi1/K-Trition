import 'package:flutter_test/flutter_test.dart';
import 'package:k_trition/app/k_trition_app.dart';

void main() {
  testWidgets('Starter opens and shows the MVP roadmap', (tester) async {
    await tester.pumpWidget(const KTritionApp());
    expect(find.text('K-Trition'), findsOneWidget);
    expect(find.text('Our K-Trition MVP'), findsOneWidget);
    expect(find.text('Food database'), findsOneWidget);
  });
}
