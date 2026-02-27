import 'package:quran_app/features/sholat/domain/entities/date.dart';
import 'package:quran_app/features/sholat/domain/entities/timings.dart';

class PrayerTimes {
  final Timings timings;
  final PrayerDate date;

  PrayerTimes({
    required this.timings,
    required this.date,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      timings: Timings.fromJson(json['timings']),
      date: PrayerDate.fromJson(json['date']),
    );
  }
}
