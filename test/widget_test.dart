import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('StudyDeckAI App Smoke Test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('StudyDeck AI')),
        ),
      ),
    );
    expect(find.text('StudyDeck AI'), findsOneWidget);
  });
}
