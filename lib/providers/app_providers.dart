import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran_app/data/services/local_storage_service.dart';

part 'app_providers.g.dart';

// Provider for the local storage service implementation
@Riverpod(keepAlive: true)
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  // Returns the mock implementation.
  // When the real implementation is ready, we can swap it here.
  return MockLocalStorageService();
}

// Provider to get the last read position
@riverpod
Future<Map<String, dynamic>?> lastRead(LastReadRef ref) {
  final service = ref.watch(localStorageServiceProvider);
  return service.getLastRead();
}

// Provider to manage the list of bookmarks
// Using StateProvider because it's simple and we'll be directly updating its state.
@riverpod
class Bookmarks extends _$Bookmarks {
  @override
  Future<List<String>> build() async {
    // Fetch initial bookmarks from the service
    return ref.watch(localStorageServiceProvider).getBookmarks();
  }

  Future<void> add(String bookmark) async {
    // Set the state to loading
    state = const AsyncValue.loading();
    // Update the service
    await ref.read(localStorageServiceProvider).addBookmark(bookmark);
    // Refetch the bookmarks and update the state
    state = await AsyncValue.guard(() => ref.read(localStorageServiceProvider).getBookmarks());
  }

  Future<void> remove(String bookmark) async {
    state = const AsyncValue.loading();
    await ref.read(localStorageServiceProvider).removeBookmark(bookmark);
    state = await AsyncValue.guard(() => ref.read(localStorageServiceProvider).getBookmarks());
  }
}
