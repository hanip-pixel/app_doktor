import 'package:flutter_test/flutter_test.dart';
import 'package:app_doktor/app.dart';

void main() {
  testWidgets('SimrsMobileApp smoke test', (WidgetTester tester) async {
    // Build aplikasi SIMRS
    await tester.pumpWidget(const SimrsMobileApp());

    // Verifikasi widget berhasil dirender
    expect(find.byType(SimrsMobileApp), findsOneWidget);
  });
}
