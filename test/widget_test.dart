import 'package:flutter_test/flutter_test.dart';
import 'package:studydeck_ai/app/app.dart';

void main() {
  testWidgets('StudyDeckAI App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyDeckApp(flavor: AppFlavor.mobile));
    expect(find.byType(StudyDeckApp), findsOneWidget);
  });
}
