// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'fcef55b74cc26bec1077866c0e4fc98e1d434122';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
      sharedPreferences,
      name: r'sharedPreferencesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sharedPreferencesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$localStorageServiceHash() =>
    r'c836f6b5413038208e76f6fe97ab94308ed0c3cc';

/// See also [localStorageService].
@ProviderFor(localStorageService)
final localStorageServiceProvider = Provider<LocalStorageService>.internal(
  localStorageService,
  name: r'localStorageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localStorageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalStorageServiceRef = ProviderRef<LocalStorageService>;
String _$lastReadHash() => r'207aef93b45f788e1635b776b1f8a545f952abb4';

/// See also [lastRead].
@ProviderFor(lastRead)
final lastReadProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>?>.internal(
      lastRead,
      name: r'lastReadProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lastReadHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastReadRef = AutoDisposeFutureProviderRef<Map<String, dynamic>?>;
String _$bookmarksHash() => r'271c91cd52132e0a9dbd06dc0685f88ed871e8ec';

/// See also [Bookmarks].
@ProviderFor(Bookmarks)
final bookmarksProvider =
    AutoDisposeAsyncNotifierProvider<Bookmarks, List<String>>.internal(
      Bookmarks.new,
      name: r'bookmarksProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$bookmarksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Bookmarks = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
