import 'package:quran_app/features/sholat/data/models/prayer_schedule.dart';

abstract class SholatRepository {
  Future<PrayerSchedule> getPrayerScheduleByCoords({
    required double latitude,
    required double longitude,
    required DateTime date,
    required String locationName,
    int method = 4,
    int school = 0,
    int latitudeAdjustmentMethod = 3,
    String tune = '0,0,0,0,0,0,0,0,0',
    int hijriAdjustment = 0,
  });

  Future<List<PrayerSchedule>> getMonthlyPrayerSchedule({
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
  });
}
