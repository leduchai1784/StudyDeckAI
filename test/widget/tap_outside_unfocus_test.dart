import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tapping outside TextField unfocuses and dismisses keyboard', (tester) async {
    final focusNode1 = FocusNode();
    final focusNode2 = FocusNode();

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: Scaffold(
          body: Column(
            children: [
              TextField(
                key: const Key('field1'),
                focusNode: focusNode1,
              ),
              TextField(
                key: const Key('field2'),
                focusNode: focusNode2,
              ),
              Container(
                key: const Key('outside'),
                width: 200,
                height: 50,
                color: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );

    // 1. Chạm vào TextField 1 -> focusNode1 có focus
    await tester.tap(find.byKey(const Key('field1')));
    await tester.pump();
    expect(focusNode1.hasFocus, isTrue);
    expect(focusNode2.hasFocus, isFalse);

    // 2. Chạm vào vùng bên ngoài -> focusNode1 mất focus
    await tester.tap(find.byKey(const Key('outside')));
    await tester.pump();
    expect(focusNode1.hasFocus, isFalse);
    expect(focusNode2.hasFocus, isFalse);

    // 3. Chạm vào TextField 2 -> focusNode2 có focus
    await tester.tap(find.byKey(const Key('field2')));
    await tester.pump();
    expect(focusNode1.hasFocus, isFalse);
    expect(focusNode2.hasFocus, isTrue);

    // 4. Chạm vào TextField 1 -> chuyển focus sang TextField 1
    await tester.tap(find.byKey(const Key('field1')));
    await tester.pump();
    expect(focusNode1.hasFocus, isTrue);
    expect(focusNode2.hasFocus, isFalse);
  });
}
