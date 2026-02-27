// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$quranRepositoryHash() => r'b58f2a186245b49711b929702ee064a5ab01c48e';

/// See also [quranRepository].
@ProviderFor(quranRepository)
final quranRepositoryProvider = AutoDisposeProvider<QuranRepository>.internal(
  quranRepository,
  name: r'quranRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$quranRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QuranRepositoryRef = AutoDisposeProviderRef<QuranRepository>;
String _$surahListHash() => r'36e15fe5b62975eaab0bf0599ae57e6063e0ed99';

/// See also [surahList].
@ProviderFor(surahList)
final surahListProvider = AutoDisposeFutureProvider<List<Surah>>.internal(
  surahList,
  name: r'surahListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$surahListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SurahListRef = AutoDisposeFutureProviderRef<List<Surah>>;
String _$surahDetailHash() => r'6a1e16ce62b818f5c2a11044742f93c9cabc46a5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [surahDetail].
@ProviderFor(surahDetail)
const surahDetailProvider = SurahDetailFamily();

/// See also [surahDetail].
class SurahDetailFamily extends Family<AsyncValue<SurahDetail>> {
  /// See also [surahDetail].
  const SurahDetailFamily();

  /// See also [surahDetail].
  SurahDetailProvider call(int surahNumber) {
    return SurahDetailProvider(surahNumber);
  }

  @override
  SurahDetailProvider getProviderOverride(
    covariant SurahDetailProvider provider,
  ) {
    return call(provider.surahNumber);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'surahDetailProvider';
}

/// See also [surahDetail].
class SurahDetailProvider extends AutoDisposeFutureProvider<SurahDetail> {
  /// See also [surahDetail].
  SurahDetailProvider(int surahNumber)
    : this._internal(
        (ref) => surahDetail(ref as SurahDetailRef, surahNumber),
        from: surahDetailProvider,
        name: r'surahDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$surahDetailHash,
        dependencies: SurahDetailFamily._dependencies,
        allTransitiveDependencies: SurahDetailFamily._allTransitiveDependencies,
        surahNumber: surahNumber,
      );

  SurahDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.surahNumber,
  }) : super.internal();

  final int surahNumber;

  @override
  Override overrideWith(
    FutureOr<SurahDetail> Function(SurahDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SurahDetailProvider._internal(
        (ref) => create(ref as SurahDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        surahNumber: surahNumber,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SurahDetail> createElement() {
    return _SurahDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SurahDetailProvider && other.surahNumber == surahNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, surahNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SurahDetailRef on AutoDisposeFutureProviderRef<SurahDetail> {
  /// The parameter `surahNumber` of this provider.
  int get surahNumber;
}

class _SurahDetailProviderElement
    extends AutoDisposeFutureProviderElement<SurahDetail>
    with SurahDetailRef {
  _SurahDetailProviderElement(super.provider);

  @override
  int get surahNumber => (origin as SurahDetailProvider).surahNumber;
}

String _$filteredSurahsHash() => r'd0a14688952a6b5db115f651766b621ce650c5c3';

/// See also [filteredSurahs].
@ProviderFor(filteredSurahs)
final filteredSurahsProvider = AutoDisposeFutureProvider<List<Surah>>.internal(
  filteredSurahs,
  name: r'filteredSurahsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredSurahsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredSurahsRef = AutoDisposeFutureProviderRef<List<Surah>>;
String _$searchQueryHash() => r'446383cb599327bea368f8da496260b05a5f9bec';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
      SearchQuery.new,
      name: r'searchQueryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchQueryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
