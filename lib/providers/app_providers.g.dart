// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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
String _$lastReadHash() => r'2a817e745c5a86e0b32a2c644419b2004cc9ff9f';

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
String _$bookmarksHash() => r'779bd9dff0365a8fa96a555ff1afb4458b85a8b8';

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
