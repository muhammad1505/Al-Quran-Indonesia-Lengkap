import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/tasbih/presentation/pages/tasbih_page.dart';

void main() {
  testWidgets('TasbihPage interaction test', (WidgetTester tester) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: TasbihPage(),
        ),
      ),
    );

    // 2. Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 3. Tap the screen to increment the counter.
    // We tap the container that says 'TAP ANYWHERE TO COUNT'.
    await tester.tap(find.text('TAP ANYWHERE TO COUNT'));
    await tester.pump(); // Rebuild the widget with the new state.

    // 4. Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);

    // 5. Tap the reset button.
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    // 6. Verify that our counter has reset.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
