// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sholat_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpClientHash() => r'ee5992436ccfa04cad4349173d374824239fea46';

/// See also [httpClient].
@ProviderFor(httpClient)
final httpClientProvider = AutoDisposeProvider<http.Client>.internal(
  httpClient,
  name: r'httpClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$httpClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpClientRef = AutoDisposeProviderRef<http.Client>;
String _$sholatRepositoryHash() => r'98d1f6d21059f1c0bb1db692fbaf382b965e76bb';

/// See also [sholatRepository].
@ProviderFor(sholatRepository)
final sholatRepositoryProvider = AutoDisposeProvider<SholatRepository>.internal(
  sholatRepository,
  name: r'sholatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sholatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SholatRepositoryRef = AutoDisposeProviderRef<SholatRepository>;
String _$prayerScheduleByCoordsHash() =>
    r'5221aa4ad688e5fcb1b7d48a10d0daf3d4adf11a';

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

/// See also [prayerScheduleByCoords].
@ProviderFor(prayerScheduleByCoords)
const prayerScheduleByCoordsProvider = PrayerScheduleByCoordsFamily();

/// See also [prayerScheduleByCoords].
class PrayerScheduleByCoordsFamily extends Family<AsyncValue<PrayerSchedule>> {
  /// See also [prayerScheduleByCoords].
  const PrayerScheduleByCoordsFamily();

  /// See also [prayerScheduleByCoords].
  PrayerScheduleByCoordsProvider call({
    required double latitude,
    required double longitude,
    required String locationName,
    int method = 4,
    int school = 0,
    int latitudeAdjustmentMethod = 3,
    String tune = '0,0,0,0,0,0,0,0,0',
    int hijriAdjustment = 0,
  }) {
    return PrayerScheduleByCoordsProvider(
      latitude: latitude,
      longitude: longitude,
      locationName: locationName,
      method: method,
      school: school,
      latitudeAdjustmentMethod: latitudeAdjustmentMethod,
      tune: tune,
      hijriAdjustment: hijriAdjustment,
    );
  }

  @override
  PrayerScheduleByCoordsProvider getProviderOverride(
    covariant PrayerScheduleByCoordsProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
      locationName: provider.locationName,
      method: provider.method,
      school: provider.school,
      latitudeAdjustmentMethod: provider.latitudeAdjustmentMethod,
      tune: provider.tune,
      hijriAdjustment: provider.hijriAdjustment,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'prayerScheduleByCoordsProvider';
}

/// See also [prayerScheduleByCoords].
class PrayerScheduleByCoordsProvider
    extends AutoDisposeFutureProvider<PrayerSchedule> {
  /// See also [prayerScheduleByCoords].
  PrayerScheduleByCoordsProvider({
    required double latitude,
    required double longitude,
    required String locationName,
    int method = 4,
    int school = 0,
    int latitudeAdjustmentMethod = 3,
    String tune = '0,0,0,0,0,0,0,0,0',
    int hijriAdjustment = 0,
  }) : this._internal(
         (ref) => prayerScheduleByCoords(
           ref as PrayerScheduleByCoordsRef,
           latitude: latitude,
           longitude: longitude,
           locationName: locationName,
           method: method,
           school: school,
           latitudeAdjustmentMethod: latitudeAdjustmentMethod,
           tune: tune,
           hijriAdjustment: hijriAdjustment,
         ),
         from: prayerScheduleByCoordsProvider,
         name: r'prayerScheduleByCoordsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$prayerScheduleByCoordsHash,
         dependencies: PrayerScheduleByCoordsFamily._dependencies,
         allTransitiveDependencies:
             PrayerScheduleByCoordsFamily._allTransitiveDependencies,
         latitude: latitude,
         longitude: longitude,
         locationName: locationName,
         method: method,
         school: school,
         latitudeAdjustmentMethod: latitudeAdjustmentMethod,
         tune: tune,
         hijriAdjustment: hijriAdjustment,
       );

  PrayerScheduleByCoordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.method,
    required this.school,
    required this.latitudeAdjustmentMethod,
    required this.tune,
    required this.hijriAdjustment,
  }) : super.internal();

  final double latitude;
  final double longitude;
  final String locationName;
  final int method;
  final int school;
  final int latitudeAdjustmentMethod;
  final String tune;
  final int hijriAdjustment;

  @override
  Override overrideWith(
    FutureOr<PrayerSchedule> Function(PrayerScheduleByCoordsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PrayerScheduleByCoordsProvider._internal(
        (ref) => create(ref as PrayerScheduleByCoordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        method: method,
        school: school,
        latitudeAdjustmentMethod: latitudeAdjustmentMethod,
        tune: tune,
        hijriAdjustment: hijriAdjustment,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PrayerSchedule> createElement() {
    return _PrayerScheduleByCoordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PrayerScheduleByCoordsProvider &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.locationName == locationName &&
        other.method == method &&
        other.school == school &&
        other.latitudeAdjustmentMethod == latitudeAdjustmentMethod &&
        other.tune == tune &&
        other.hijriAdjustment == hijriAdjustment;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);
    hash = _SystemHash.combine(hash, locationName.hashCode);
    hash = _SystemHash.combine(hash, method.hashCode);
    hash = _SystemHash.combine(hash, school.hashCode);
    hash = _SystemHash.combine(hash, latitudeAdjustmentMethod.hashCode);
    hash = _SystemHash.combine(hash, tune.hashCode);
    hash = _SystemHash.combine(hash, hijriAdjustment.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PrayerScheduleByCoordsRef
    on AutoDisposeFutureProviderRef<PrayerSchedule> {
  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;

  /// The parameter `locationName` of this provider.
  String get locationName;

  /// The parameter `method` of this provider.
  int get method;

  /// The parameter `school` of this provider.
  int get school;

  /// The parameter `latitudeAdjustmentMethod` of this provider.
  int get latitudeAdjustmentMethod;

  /// The parameter `tune` of this provider.
  String get tune;

  /// The parameter `hijriAdjustment` of this provider.
  int get hijriAdjustment;
}

class _PrayerScheduleByCoordsProviderElement
    extends AutoDisposeFutureProviderElement<PrayerSchedule>
    with PrayerScheduleByCoordsRef {
  _PrayerScheduleByCoordsProviderElement(super.provider);

  @override
  double get latitude => (origin as PrayerScheduleByCoordsProvider).latitude;
  @override
  double get longitude => (origin as PrayerScheduleByCoordsProvider).longitude;
  @override
  String get locationName =>
      (origin as PrayerScheduleByCoordsProvider).locationName;
  @override
  int get method => (origin as PrayerScheduleByCoordsProvider).method;
  @override
  int get school => (origin as PrayerScheduleByCoordsProvider).school;
  @override
  int get latitudeAdjustmentMethod =>
      (origin as PrayerScheduleByCoordsProvider).latitudeAdjustmentMethod;
  @override
  String get tune => (origin as PrayerScheduleByCoordsProvider).tune;
  @override
  int get hijriAdjustment =>
      (origin as PrayerScheduleByCoordsProvider).hijriAdjustment;
}

String _$monthlyPrayerScheduleByCoordsHash() =>
    r'1ff357c2f81a184dc3a34473bb0215fdc1a5a9a5';

/// See also [monthlyPrayerScheduleByCoords].
@ProviderFor(monthlyPrayerScheduleByCoords)
const monthlyPrayerScheduleByCoordsProvider =
    MonthlyPrayerScheduleByCoordsFamily();

/// See also [monthlyPrayerScheduleByCoords].
class MonthlyPrayerScheduleByCoordsFamily
    extends Family<AsyncValue<List<PrayerSchedule>>> {
  /// See also [monthlyPrayerScheduleByCoords].
  const MonthlyPrayerScheduleByCoordsFamily();

  /// See also [monthlyPrayerScheduleByCoords].
  MonthlyPrayerScheduleByCoordsProvider call({
    required double latitude,
    required double longitude,
    required int month,
    required int year,
    required String locationName,
    int method = 4,
    int school = 0,
    int latitudeAdjustmentMethod = 3,
    String tune = '0,0,0,0,0,0,0,0,0',
    int hijriAdjustment = 0,
  }) {
    return MonthlyPrayerScheduleByCoordsProvider(
      latitude: latitude,
      longitude: longitude,
      month: month,
      year: year,
      locationName: locationName,
      method: method,
      school: school,
      latitudeAdjustmentMethod: latitudeAdjustmentMethod,
      tune: tune,
      hijriAdjustment: hijriAdjustment,
    );
  }

  @override
  MonthlyPrayerScheduleByCoordsProvider getProviderOverride(
    covariant MonthlyPrayerScheduleByCoordsProvider provider,
  ) {
    return call(
      latitude: provider.latitude,
      longitude: provider.longitude,
      month: provider.month,
      year: provider.year,
      locationName: provider.locationName,
      method: provider.method,
      school: provider.school,
      latitudeAdjustmentMethod: provider.latitudeAdjustmentMethod,
      tune: provider.tune,
      hijriAdjustment: provider.hijriAdjustment,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyPrayerScheduleByCoordsProvider';
}

/// See also [monthlyPrayerScheduleByCoords].
class MonthlyPrayerScheduleByCoordsProvider
    extends AutoDisposeFutureProvider<List<PrayerSchedule>> {
  /// See also [monthlyPrayerScheduleByCoords].
  MonthlyPrayerScheduleByCoordsProvider({
    required double latitude,
    required double longitude,
    required int month,
    required int year,
    required String locationName,
    int method = 4,
    int school = 0,
    int latitudeAdjustmentMethod = 3,
    String tune = '0,0,0,0,0,0,0,0,0',
    int hijriAdjustment = 0,
  }) : this._internal(
         (ref) => monthlyPrayerScheduleByCoords(
           ref as MonthlyPrayerScheduleByCoordsRef,
           latitude: latitude,
           longitude: longitude,
           month: month,
           year: year,
           locationName: locationName,
           method: method,
           school: school,
           latitudeAdjustmentMethod: latitudeAdjustmentMethod,
           tune: tune,
           hijriAdjustment: hijriAdjustment,
         ),
         from: monthlyPrayerScheduleByCoordsProvider,
         name: r'monthlyPrayerScheduleByCoordsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$monthlyPrayerScheduleByCoordsHash,
         dependencies: MonthlyPrayerScheduleByCoordsFamily._dependencies,
         allTransitiveDependencies:
             MonthlyPrayerScheduleByCoordsFamily._allTransitiveDependencies,
         latitude: latitude,
         longitude: longitude,
         month: month,
         year: year,
         locationName: locationName,
         method: method,
         school: school,
         latitudeAdjustmentMethod: latitudeAdjustmentMethod,
         tune: tune,
         hijriAdjustment: hijriAdjustment,
       );

  MonthlyPrayerScheduleByCoordsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.latitude,
    required this.longitude,
    required this.month,
    required this.year,
    required this.locationName,
    required this.method,
    required this.school,
    required this.latitudeAdjustmentMethod,
    required this.tune,
    required this.hijriAdjustment,
  }) : super.internal();

  final double latitude;
  final double longitude;
  final int month;
  final int year;
  final String locationName;
  final int method;
  final int school;
  final int latitudeAdjustmentMethod;
  final String tune;
  final int hijriAdjustment;

  @override
  Override overrideWith(
    FutureOr<List<PrayerSchedule>> Function(
      MonthlyPrayerScheduleByCoordsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyPrayerScheduleByCoordsProvider._internal(
        (ref) => create(ref as MonthlyPrayerScheduleByCoordsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        latitude: latitude,
        longitude: longitude,
        month: month,
        year: year,
        locationName: locationName,
        method: method,
        school: school,
        latitudeAdjustmentMethod: latitudeAdjustmentMethod,
        tune: tune,
        hijriAdjustment: hijriAdjustment,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<PrayerSchedule>> createElement() {
    return _MonthlyPrayerScheduleByCoordsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyPrayerScheduleByCoordsProvider &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.month == month &&
        other.year == year &&
        other.locationName == locationName &&
        other.method == method &&
        other.school == school &&
        other.latitudeAdjustmentMethod == latitudeAdjustmentMethod &&
        other.tune == tune &&
        other.hijriAdjustment == hijriAdjustment;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, latitude.hashCode);
    hash = _SystemHash.combine(hash, longitude.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, locationName.hashCode);
    hash = _SystemHash.combine(hash, method.hashCode);
    hash = _SystemHash.combine(hash, school.hashCode);
    hash = _SystemHash.combine(hash, latitudeAdjustmentMethod.hashCode);
    hash = _SystemHash.combine(hash, tune.hashCode);
    hash = _SystemHash.combine(hash, hijriAdjustment.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyPrayerScheduleByCoordsRef
    on AutoDisposeFutureProviderRef<List<PrayerSchedule>> {
  /// The parameter `latitude` of this provider.
  double get latitude;

  /// The parameter `longitude` of this provider.
  double get longitude;

  /// The parameter `month` of this provider.
  int get month;

  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `locationName` of this provider.
  String get locationName;

  /// The parameter `method` of this provider.
  int get method;

  /// The parameter `school` of this provider.
  int get school;

  /// The parameter `latitudeAdjustmentMethod` of this provider.
  int get latitudeAdjustmentMethod;

  /// The parameter `tune` of this provider.
  String get tune;

  /// The parameter `hijriAdjustment` of this provider.
  int get hijriAdjustment;
}

class _MonthlyPrayerScheduleByCoordsProviderElement
    extends AutoDisposeFutureProviderElement<List<PrayerSchedule>>
    with MonthlyPrayerScheduleByCoordsRef {
  _MonthlyPrayerScheduleByCoordsProviderElement(super.provider);

  @override
  double get latitude =>
      (origin as MonthlyPrayerScheduleByCoordsProvider).latitude;
  @override
  double get longitude =>
      (origin as MonthlyPrayerScheduleByCoordsProvider).longitude;
  @override
  int get month => (origin as MonthlyPrayerScheduleByCoordsProvider).month;
  @override
  int get year => (origin as MonthlyPrayerScheduleByCoordsProvider).year;
  @override
  String get locationName =>
      (origin as MonthlyPrayerScheduleByCoordsProvider).locationName;
  @override
  int get method => (origin as MonthlyPrayerScheduleByCoordsProvider).method;
  @override
  int get school => (origin as MonthlyPrayerScheduleByCoordsProvider).school;
  @override
  int get latitudeAdjustmentMethod =>
      (origin as MonthlyPrayerScheduleByCoordsProvider)
          .latitudeAdjustmentMethod;
  @override
  String get tune => (origin as MonthlyPrayerScheduleByCoordsProvider).tune;
  @override
  int get hijriAdjustment =>
      (origin as MonthlyPrayerScheduleByCoordsProvider).hijriAdjustment;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
