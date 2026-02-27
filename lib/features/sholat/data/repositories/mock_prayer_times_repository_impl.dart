import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_app/features/sholat/domain/entities/prayer_times.dart';
import 'package:quran_app/features/sholat/domain/repositories/prayer_times_repository.dart';

class MockPrayerTimesRepositoryImpl implements PrayerTimesRepository {
  @override
  Future<PrayerTimes> getPrayerTimes({
    required String city,
    required String country,
  }) async {
    // In the mock implementation, we ignore the parameters and use the sample file.
    final String response = await rootBundle.loadString('assets/data/prayer_times_sample.json');
    final data = await json.decode(response);
    return PrayerTimes.fromJson(data['data']);
  }
}
