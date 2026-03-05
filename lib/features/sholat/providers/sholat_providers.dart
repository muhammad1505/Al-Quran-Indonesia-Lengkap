import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran_app/features/sholat/data/models/prayer_schedule.dart';
import 'package:quran_app/features/sholat/data/repositories/sholat_repository_impl.dart';
import 'package:quran_app/features/sholat/domain/repositories/sholat_repository.dart';

part 'sholat_providers.g.dart';

// Provider for the http client
@riverpod
http.Client httpClient(HttpClientRef ref) {
  return http.Client();
}

// Provider for the SholatRepository
@riverpod
SholatRepository sholatRepository(SholatRepositoryRef ref) {
  return SholatRepositoryImpl(ref.watch(httpClientProvider));
}

// Provider to get the prayer schedule by coordinates
@riverpod
Future<PrayerSchedule> prayerScheduleByCoords(
  PrayerScheduleByCoordsRef ref, {
  required double latitude,
  required double longitude,
  required String locationName,
  int method = 4,
  int school = 0,
  int latitudeAdjustmentMethod = 3,
  String tune = '0,0,0,0,0,0,0,0,0',
  int hijriAdjustment = 0,
}) async {
  final repository = ref.watch(sholatRepositoryProvider);
  return repository.getPrayerScheduleByCoords(
    latitude: latitude,
    longitude: longitude,
    date: DateTime.now(),
    locationName: locationName,
    method: method,
    school: school,
    latitudeAdjustmentMethod: latitudeAdjustmentMethod,
    tune: tune,
    hijriAdjustment: hijriAdjustment,
  );
}

// Provider to get the monthly prayer schedule
@riverpod
Future<List<PrayerSchedule>> monthlyPrayerScheduleByCoords(
  MonthlyPrayerScheduleByCoordsRef ref, {
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
}) async {
  final repository = ref.watch(sholatRepositoryProvider);
  return repository.getMonthlyPrayerSchedule(
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
