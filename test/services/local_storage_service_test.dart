import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/data/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPreferencesLocalStorageService', () {
    late SharedPreferencesLocalStorageService service;
    late SharedPreferences prefs;

    setUp(() async {
      // Set up mock initial values for SharedPreferences
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      service = SharedPreferencesLocalStorageService(prefs);
    });

    group('lastRead', () {
      test('getLastRead should return null when no data is saved', () async {
        // Act
        final result = await service.getLastRead();
        // Assert
        expect(result, isNull);
      });

      test('saveLastRead and getLastRead should work correctly', () async {
        // Arrange
        final lastReadData = {
          'surahNumber': 1,
          'surahName': 'Al-Fatihah',
          'ayahNumber': 5,
        };

        // Act
        await service.saveLastRead(
          surahNumber: lastReadData['surahNumber'] as int,
          surahName: lastReadData['surahName'] as String,
          ayahNumber: lastReadData['ayahNumber'] as int,
        );
        final result = await service.getLastRead();

        // Assert
        expect(result, isA<Map<String, dynamic>>());
        expect(result, equals(lastReadData));
      });
    });

    group('bookmarks', () {
      test('getBookmarks should return an empty list initially', () async {
        // Act
        final result = await service.getBookmarks();
        // Assert
        expect(result, isA<List<String>>());
        expect(result, isEmpty);
      });

      test('addBookmark should add a bookmark', () async {
        // Arrange
        const bookmark = '1:5';

        // Act
        await service.addBookmark(bookmark);
        final result = await service.getBookmarks();

        // Assert
        expect(result, contains(bookmark));
        expect(result.length, 1);
      });

      test('addBookmark should not add a duplicate bookmark', () async {
        // Arrange
        const bookmark = '1:5';
        await service.addBookmark(bookmark);

        // Act
        await service.addBookmark(bookmark);
        final result = await service.getBookmarks();

        // Assert
        expect(result.length, 1);
      });

      test('removeBookmark should remove an existing bookmark', () async {
        // Arrange
        const bookmark1 = '1:5';
        const bookmark2 = '2:10';
        await service.addBookmark(bookmark1);
        await service.addBookmark(bookmark2);

        // Act
        await service.removeBookmark(bookmark1);
        final result = await service.getBookmarks();

        // Assert
        expect(result, isNot(contains(bookmark1)));
        expect(result, contains(bookmark2));
        expect(result.length, 1);
      });
    });
  });
}
