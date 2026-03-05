import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran_app/data/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_providers.g.dart';

// Provider for the SharedPreferences instance
@riverpod
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) {
  return SharedPreferences.getInstance();
}

// Provider for the local storage service implementation
@Riverpod(keepAlive: true)
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  // The provider is overridden in main.dart during app initialization
  // to provide the real implementation. This is a fallback.
  return MockLocalStorageService();
}

// Provider to get the last read position
@riverpod
Future<Map<String, dynamic>?> lastRead(LastReadRef ref) async {
  final service = ref.watch(localStorageServiceProvider);
  return service.getLastRead();
}

// Provider to manage the list of bookmarks
@riverpod
class Bookmarks extends _$Bookmarks {
  @override
  Future<List<String>> build() async {
    // Fetch initial bookmarks from the service
    final service = ref.watch(localStorageServiceProvider);
    return service.getBookmarks();
  }

  Future<void> add(String bookmark) async {
    final service = ref.read(localStorageServiceProvider);
    // Set the state to loading
    state = const AsyncValue.loading();
    // Update the service
    await service.addBookmark(bookmark);
    // Refetch the bookmarks and update the state
    state = await AsyncValue.guard(service.getBookmarks);
  }

  Future<void> remove(String bookmark) async {
    final service = ref.read(localStorageServiceProvider);
    state = const AsyncValue.loading();
    await service.removeBookmark(bookmark);
    state = await AsyncValue.guard(service.getBookmarks);
  }
}
