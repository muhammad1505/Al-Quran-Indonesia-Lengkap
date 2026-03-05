import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum RasmType { utsmani, indoPak }

enum TranslationType { kemenAg, tafsirJalalain }

/// Aladhan API calculation methods
enum PrayerCalcMethod {
  shpiahUnivTehran(0, 'Shia Ithna-Ashari, Leva Institute, Qum'),
  universityIslamicSciKarachi(1, 'University of Islamic Sciences, Karachi'),
  islamicSocietyNorthAmerica(2, 'Islamic Society of North America (ISNA)'),
  muslimWorldLeague(3, 'Muslim World League'),
  ummAlQura(4, 'Umm Al-Qura University, Makkah'),
  egyptianGeneralAuthority(5, 'Egyptian General Authority of Survey'),
  instituteOfGeophysicsTehran(7, 'Institute of Geophysics, University of Tehran'),
  gulfRegion(8, 'Gulf Region'),
  kuwait(9, 'Kuwait'),
  qatar(10, 'Qatar'),
  majlisUgamaIslamSingapura(11, 'Majlis Ugama Islam Singapura, Singapore'),
  unionOrganizationIslamicFrance(12, 'Union Organization Islamic de France'),
  diyanetIsleriBaskanligiTurkey(13, 'Diyanet İşleri Başkanlığı, Turkey'),
  spiritualAdminMuslimsRussia(14, 'Spiritual Administration of Muslims of Russia'),
  mohammadiyah(15, 'Mohamadiyah, Indonesia'),
  kemenagRI(20, 'Kemenag RI (Sihat)'); // Method 20 for Kemenag

  final int apiValue;
  final String label;
  const PrayerCalcMethod(this.apiValue, this.label);
}

/// Asr calculation school
enum AsrSchool {
  shafiMalikiHanbali(0, "Syafi'i / Maliki / Hanbali"),
  hanafi(1, 'Hanafi');

  final int apiValue;
  final String label;
  const AsrSchool(this.apiValue, this.label);
}

/// Latitude adjustment method
enum LatitudeAdjustment {
  middleOfTheNight(1, 'Tengah Malam'),
  oneSeventhOfTheNight(2, 'Sepertujuh Malam'),
  angleBased(3, 'Berbasis Sudut');

  final int apiValue;
  final String label;
  const LatitudeAdjustment(this.apiValue, this.label);
}

class SettingsState {
  final bool showTransliteration;
  final bool isTajwidMode;
  final RasmType rasmType;
  final TranslationType translationType;

  // Prayer time settings
  final bool autoCalcMethod;
  final PrayerCalcMethod prayerCalcMethod;
  final AsrSchool asrSchool;
  final LatitudeAdjustment latitudeAdjustment;
  final Map<String, int> prayerTimeAdjustments;

  // Hijri settings
  final bool autoHijriMethod;
  final int hijriAdjustment; // -2 to +2

  // Notification settings
  final Map<String, bool> prayerNotifications;
  final bool dzikirPagiReminder;
  final bool dzikirPetangReminder;
  final int preAdzanMinutes; // minutes before adzan

  // Other
  final bool use24HourFormat;

  const SettingsState({
    this.showTransliteration = true,
    this.isTajwidMode = false,
    this.rasmType = RasmType.utsmani,
    this.translationType = TranslationType.kemenAg,
    // Prayer defaults
    this.autoCalcMethod = true,
    this.prayerCalcMethod = PrayerCalcMethod.kemenagRI,
    this.asrSchool = AsrSchool.shafiMalikiHanbali,
    this.latitudeAdjustment = LatitudeAdjustment.angleBased,
    this.prayerTimeAdjustments = const {
      'Imsak': 0, 'Fajr': 0, 'Sunrise': 0, 'Dhuhr': 0,
      'Asr': 0, 'Maghrib': 0, 'Isha': 0,
    },
    // Hijri defaults
    this.autoHijriMethod = true,
    this.hijriAdjustment = 1, // Default adjustment for Indonesia
    // Notification defaults
    this.prayerNotifications = const {
      'Subuh': true, 'Dzuhur': true, 'Ashar': true,
      'Maghrib': true, 'Isya': true,
    },
    this.dzikirPagiReminder = false,
    this.dzikirPetangReminder = false,
    this.preAdzanMinutes = 0,
    // Other
    this.use24HourFormat = true,
  });

  SettingsState copyWith({
    bool? showTransliteration,
    bool? isTajwidMode,
    RasmType? rasmType,
    TranslationType? translationType,
    bool? autoCalcMethod,
    PrayerCalcMethod? prayerCalcMethod,
    AsrSchool? asrSchool,
    LatitudeAdjustment? latitudeAdjustment,
    Map<String, int>? prayerTimeAdjustments,
    bool? autoHijriMethod,
    int? hijriAdjustment,
    Map<String, bool>? prayerNotifications,
    bool? dzikirPagiReminder,
    bool? dzikirPetangReminder,
    int? preAdzanMinutes,
    bool? use24HourFormat,
  }) {
    return SettingsState(
      showTransliteration: showTransliteration ?? this.showTransliteration,
      isTajwidMode: isTajwidMode ?? this.isTajwidMode,
      rasmType: rasmType ?? this.rasmType,
      translationType: translationType ?? this.translationType,
      autoCalcMethod: autoCalcMethod ?? this.autoCalcMethod,
      prayerCalcMethod: prayerCalcMethod ?? this.prayerCalcMethod,
      asrSchool: asrSchool ?? this.asrSchool,
      latitudeAdjustment: latitudeAdjustment ?? this.latitudeAdjustment,
      prayerTimeAdjustments: prayerTimeAdjustments ?? this.prayerTimeAdjustments,
      autoHijriMethod: autoHijriMethod ?? this.autoHijriMethod,
      hijriAdjustment: hijriAdjustment ?? this.hijriAdjustment,
      prayerNotifications: prayerNotifications ?? this.prayerNotifications,
      dzikirPagiReminder: dzikirPagiReminder ?? this.dzikirPagiReminder,
      dzikirPetangReminder: dzikirPetangReminder ?? this.dzikirPetangReminder,
      preAdzanMinutes: preAdzanMinutes ?? this.preAdzanMinutes,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
    );
  }

  /// Build the Aladhan 'tune' query param from personal adjustments
  String get tuneString {
    final vals = [
      prayerTimeAdjustments['Imsak'] ?? 0,
      prayerTimeAdjustments['Fajr'] ?? 0,
      prayerTimeAdjustments['Sunrise'] ?? 0,
      prayerTimeAdjustments['Dhuhr'] ?? 0,
      prayerTimeAdjustments['Asr'] ?? 0,
      prayerTimeAdjustments['Maghrib'] ?? 0,
      0, // Sunset (not adjustable)
      prayerTimeAdjustments['Isha'] ?? 0,
      0, // Midnight (not adjustable)
    ];
    return vals.join(',');
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences prefs;

  SettingsNotifier(this.prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    // Load prayer time adjustments
    Map<String, int> adjustments = {
      'Imsak': 0, 'Fajr': 0, 'Sunrise': 0, 'Dhuhr': 0,
      'Asr': 0, 'Maghrib': 0, 'Isha': 0,
    };
    for (final key in adjustments.keys) {
      adjustments[key] = prefs.getInt('tune_$key') ?? 0;
    }

    state = SettingsState(
      showTransliteration: prefs.getBool('showTransliteration') ?? true,
      isTajwidMode: prefs.getBool('isTajwidMode') ?? false,
      rasmType: RasmType.values[prefs.getInt('rasmType') ?? 0],
      translationType: TranslationType.values[prefs.getInt('translationType') ?? 0],
      // Prayer
      autoCalcMethod: prefs.getBool('autoCalcMethod') ?? true,
      prayerCalcMethod: PrayerCalcMethod.values[prefs.getInt('prayerCalcMethod') ?? PrayerCalcMethod.kemenagRI.index],
      asrSchool: AsrSchool.values[prefs.getInt('asrSchool') ?? 0],
      latitudeAdjustment: LatitudeAdjustment.values[prefs.getInt('latitudeAdjustment') ?? 2], // angleBased index
      prayerTimeAdjustments: adjustments,
      // Hijri
      autoHijriMethod: prefs.getBool('autoHijriMethod') ?? true,
      hijriAdjustment: prefs.getInt('hijriAdjustment') ?? 1,
      // Notifications
      prayerNotifications: {
        'Subuh': prefs.getBool('notif_Subuh') ?? true,
        'Dzuhur': prefs.getBool('notif_Dzuhur') ?? true,
        'Ashar': prefs.getBool('notif_Ashar') ?? true,
        'Maghrib': prefs.getBool('notif_Maghrib') ?? true,
        'Isya': prefs.getBool('notif_Isya') ?? true,
      },
      dzikirPagiReminder: prefs.getBool('dzikirPagiReminder') ?? false,
      dzikirPetangReminder: prefs.getBool('dzikirPetangReminder') ?? false,
      preAdzanMinutes: prefs.getInt('preAdzanMinutes') ?? 0,
      // Other
      use24HourFormat: prefs.getBool('use24HourFormat') ?? true,
    );
  }

  Future<void> toggleTransliteration(bool value) async {
    state = state.copyWith(showTransliteration: value);
    await prefs.setBool('showTransliteration', value);
  }

  Future<void> toggleTajwidMode(bool value) async {
    state = state.copyWith(isTajwidMode: value);
    await prefs.setBool('isTajwidMode', value);
  }

  Future<void> setRasmType(RasmType type) async {
    state = state.copyWith(rasmType: type);
    await prefs.setInt('rasmType', type.index);
  }

  Future<void> setTranslationType(TranslationType type) async {
    state = state.copyWith(translationType: type);
    await prefs.setInt('translationType', type.index);
  }

  // ── Prayer settings ──
  Future<void> setAutoCalcMethod(bool value) async {
    state = state.copyWith(autoCalcMethod: value);
    await prefs.setBool('autoCalcMethod', value);
    if (value) {
      // Reset to Kemenag default
      state = state.copyWith(prayerCalcMethod: PrayerCalcMethod.kemenagRI);
      await prefs.setInt('prayerCalcMethod', PrayerCalcMethod.kemenagRI.index);
    }
  }

  Future<void> setPrayerCalcMethod(PrayerCalcMethod method) async {
    state = state.copyWith(prayerCalcMethod: method, autoCalcMethod: false);
    await prefs.setInt('prayerCalcMethod', method.index);
    await prefs.setBool('autoCalcMethod', false);
  }

  Future<void> setAsrSchool(AsrSchool school) async {
    state = state.copyWith(asrSchool: school);
    await prefs.setInt('asrSchool', school.index);
  }

  Future<void> setLatitudeAdjustment(LatitudeAdjustment adj) async {
    state = state.copyWith(latitudeAdjustment: adj);
    await prefs.setInt('latitudeAdjustment', adj.index);
  }

  Future<void> setPrayerTimeAdjustment(String prayerName, int minutes) async {
    final newMap = Map<String, int>.from(state.prayerTimeAdjustments);
    newMap[prayerName] = minutes.clamp(-30, 30);
    state = state.copyWith(prayerTimeAdjustments: newMap);
    await prefs.setInt('tune_$prayerName', newMap[prayerName]!);
  }

  Future<void> resetPrayerTimeAdjustments() async {
    final newMap = <String, int>{
      'Imsak': 0, 'Fajr': 0, 'Sunrise': 0, 'Dhuhr': 0,
      'Asr': 0, 'Maghrib': 0, 'Isha': 0,
    };
    state = state.copyWith(prayerTimeAdjustments: newMap);
    for (final key in newMap.keys) {
      await prefs.setInt('tune_$key', 0);
    }
  }

  // ── Hijri settings ──
  Future<void> setAutoHijriMethod(bool value) async {
    state = state.copyWith(autoHijriMethod: value);
    await prefs.setBool('autoHijriMethod', value);
  }

  Future<void> setHijriAdjustment(int value) async {
    state = state.copyWith(hijriAdjustment: value.clamp(-2, 2));
    await prefs.setInt('hijriAdjustment', value.clamp(-2, 2));
  }

  // ── Other ──
  Future<void> setUse24HourFormat(bool value) async {
    state = state.copyWith(use24HourFormat: value);
    await prefs.setBool('use24HourFormat', value);
  }

  // ── Notification settings ──
  Future<void> setPrayerNotification(String prayerName, bool enabled) async {
    final newMap = Map<String, bool>.from(state.prayerNotifications);
    newMap[prayerName] = enabled;
    state = state.copyWith(prayerNotifications: newMap);
    await prefs.setBool('notif_$prayerName', enabled);
  }

  Future<void> setDzikirPagiReminder(bool value) async {
    state = state.copyWith(dzikirPagiReminder: value);
    await prefs.setBool('dzikirPagiReminder', value);
  }

  Future<void> setDzikirPetangReminder(bool value) async {
    state = state.copyWith(dzikirPetangReminder: value);
    await prefs.setBool('dzikirPetangReminder', value);
  }

  Future<void> setPreAdzanMinutes(int value) async {
    state = state.copyWith(preAdzanMinutes: value.clamp(0, 30));
    await prefs.setInt('preAdzanMinutes', value.clamp(0, 30));
  }
}

// 1. Provider for SharedPreferences instance (must be overridden in main.dart)
final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPrefsProvider must be overridden');
});

// 2. StateNotifierProvider for Settings
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  return SettingsNotifier(prefs);
});
