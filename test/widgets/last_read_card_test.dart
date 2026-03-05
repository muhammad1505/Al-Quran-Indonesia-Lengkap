import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/quran/presentation/widgets/last_read_card.dart';

void main() {
  testWidgets('LastReadCard displays surah name and ayah number', (WidgetTester tester) async {
    // Arrange
    const surahName = 'Al-Fatihah';
    const ayahNumber = 5;
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LastReadCard(
            surahName: surahName,
            ayahNumber: ayahNumber,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    // Act & Assert
    // Verify that the title text is displayed.
    expect(find.text('TERAKHIR DIBACA'), findsOneWidget);

    // Verify that the surah name and ayah number are displayed together.
    expect(find.text('$surahName, Ayat $ayahNumber'), findsOneWidget);

    // Verify the icon is present.
    expect(find.byIcon(Icons.history_rounded), findsOneWidget);

    // Simulate a tap on the card.
    await tester.tap(find.byType(LastReadCard));
    await tester.pump();

    // Verify that the onTap callback was triggered.
    expect(tapped, isTrue);
  });
}
