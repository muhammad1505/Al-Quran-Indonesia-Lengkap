import 'package:quran_app/features/sholat/domain/entities/prayer_times.dart';

abstract class PrayerTimesRepository {
  Future<PrayerTimes> getPrayerTimes({
    required String city,
    required String country,
  });
}
