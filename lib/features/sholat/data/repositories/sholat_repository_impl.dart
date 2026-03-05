import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quran_app/features/sholat/data/models/prayer_schedule.dart';
import 'package:quran_app/features/sholat/domain/repositories/sholat_repository.dart';

class SholatRepositoryImpl implements SholatRepository {
  final http.Client client;

  SholatRepositoryImpl(this.client);

  @override
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
  }) async {
    final dateStr =
        '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';

    final url = Uri.parse(
      'https://api.aladhan.com/v1/timings/$dateStr'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&method=$method'
      '&school=$school'
      '&latitudeAdjustmentMethod=$latitudeAdjustmentMethod'
      '&tune=$tune'
      '&adjustment=$hijriAdjustment',
    );

    final response = await client.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['code'] == 200) {
        final data = result['data'] as Map<String, dynamic>;
        return PrayerSchedule.fromAladhanJson(data, locationName);
      } else {
        throw Exception('API error: ${result['status']}');
      }
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }

  @override
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
  }) async {
    final url = Uri.parse(
      'https://api.aladhan.com/v1/calendar/$year/$month'
      '?latitude=$latitude'
      '&longitude=$longitude'
      '&method=$method'
      '&school=$school'
      '&latitudeAdjustmentMethod=$latitudeAdjustmentMethod'
      '&tune=$tune'
      '&adjustment=$hijriAdjustment',
    );

    final response = await client.get(url).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['code'] == 200) {
        final days = result['data'] as List;
        return days
            .map((dayData) =>
                PrayerSchedule.fromAladhanJson(dayData as Map<String, dynamic>, locationName))
            .toList();
      } else {
        throw Exception('API error: ${result['status']}');
      }
    } else {
      throw Exception('HTTP ${response.statusCode}');
    }
  }
}
