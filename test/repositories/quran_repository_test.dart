import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/data/repositories/quran_repository_impl.dart';
import 'package:quran_app/domain/entities/surah.dart';

// Helper to mock asset loading
// See: https://docs.flutter.dev/testing/cookbook/testing-assets
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranRepositoryImpl', () {
    late QuranRepositoryImpl repository;
    final mockSurahsJson = '''
    [
      {
        "number": 1,
        "name": "سُورَةُ ٱلْفَاتِحَةِ",
        "transliteration_en": "Al-Fatihah",
        "translation_en": "The Opening",
        "total_verses": 7,
        "revelation_type": "Meccan"
      },
      {
        "number": 2,
        "name": "سُورَةُ ٱلْبَقَرَةِ",
        "transliteration_en": "Al-Baqarah",
        "translation_en": "The Cow",
        "total_verses": 286,
        "revelation_type": "Medinan"
      }
    ]
    ''';

    setUp(() {
      repository = QuranRepositoryImpl();
      // Mock the rootBundle to return our fake JSON
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        if (message == null) return null;
        final String key = utf8.decode(message.buffer.asUint8List());
        if (key == 'assets/data/surahs.json') {
          return ByteData.view(utf8.encoder.convert(mockSurahsJson).buffer);
        }
        return null;
      });
    });

    test('getSurahs returns a list of Surahs when parsing is successful', () async {
      // Act
      final result = await repository.getSurahs();

      // Assert
      expect(result, isA<List<Surah>>());
      expect(result.length, 2);
      expect(result[0].number, 1);
      expect(result[0].transliterationEn, 'Al-Fatihah');
      expect(result[1].number, 2);
      expect(result[1].totalVerses, 286);
    });
  });
}
