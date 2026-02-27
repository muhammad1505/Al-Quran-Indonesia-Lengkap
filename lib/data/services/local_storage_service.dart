// Represents the contract for our local storage.
// In a real app, the implementation would use shared_preferences.
abstract class LocalStorageService {
  Future<void> saveLastRead({required int surahNumber, required String surahName, required int ayahNumber});
  Future<Map<String, dynamic>?> getLastRead();
  
  Future<void> addBookmark(String bookmark);
  Future<void> removeBookmark(String bookmark);
  Future<List<String>> getBookmarks();
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
  Future<void> saveLastRead({required int surahNumber, required String surahName, required int ayahNumber}) async {
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
}
