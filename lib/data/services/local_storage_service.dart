import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Represents the contract for our local storage.
abstract class LocalStorageService {
  Future<void> saveLastRead(
      {required int surahNumber,
      required String surahName,
      required int ayahNumber});
  Future<Map<String, dynamic>?> getLastRead();

  Future<void> addBookmark(String bookmark);
  Future<void> removeBookmark(String bookmark);
  Future<List<String>> getBookmarks();
  Future<void> clearBookmarks();
}

/// A new implementation that uses SharedPreferences for persistent storage.
class SharedPreferencesLocalStorageService implements LocalStorageService {
  final SharedPreferences _prefs;

  SharedPreferencesLocalStorageService(this._prefs);

  static const _lastReadKey = 'lastRead';
  static const _bookmarksKey = 'bookmarks';

  @override
  Future<Map<String, dynamic>?> getLastRead() async {
    final jsonString = _prefs.getString(_lastReadKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Future<void> saveLastRead(
      {required int surahNumber,
      required String surahName,
      required int ayahNumber}) async {
    final lastReadMap = {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
    };
    await _prefs.setString(_lastReadKey, jsonEncode(lastReadMap));
  }

  @override
  Future<void> addBookmark(String bookmark) async {
    final bookmarks = await getBookmarks();
    if (!bookmarks.contains(bookmark)) {
      bookmarks.add(bookmark);
      await _prefs.setStringList(_bookmarksKey, bookmarks);
    }
  }

  @override
  Future<List<String>> getBookmarks() async {
    return _prefs.getStringList(_bookmarksKey) ?? [];
  }

  @override
  Future<void> removeBookmark(String bookmark) async {
    final bookmarks = await getBookmarks();
    bookmarks.remove(bookmark);
    await _prefs.setStringList(_bookmarksKey, bookmarks);
  }

  @override
  Future<void> clearBookmarks() async {
    await _prefs.remove(_bookmarksKey);
  }
}


// A mock implementation that stores data in memory.
// Data will be lost when the app restarts.
class MockLocalStorageService implements LocalStorageService {
  Map<String, dynamic>? _lastRead;
  final List<String> _bookmarks = [];

  @override
  Future<Map<String, dynamic>?> getLastRead() async {
    return _lastRead;
  }

  @override
  Future<void> saveLastRead(
      {required int surahNumber,
      required String surahName,
      required int ayahNumber}) async {
    _lastRead = {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
    };
  }

  @override
  Future<void> addBookmark(String bookmark) async {
    if (!_bookmarks.contains(bookmark)) {
      _bookmarks.add(bookmark);
    }
  }

  @override
  Future<List<String>> getBookmarks() async {
    return _bookmarks;
  }

  @override
  Future<void> removeBookmark(String bookmark) async {
    _bookmarks.remove(bookmark);
  }

  @override
  Future<void> clearBookmarks() async {
    _bookmarks.clear();
  }
}
