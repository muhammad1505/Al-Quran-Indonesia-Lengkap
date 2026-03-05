import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quran_app/features/sholat/data/models/prayer_schedule.dart';
import 'package:quran_app/features/sholat/data/repositories/sholat_repository_impl.dart';

import 'sholat_repository_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late SholatRepositoryImpl repository;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    repository = SholatRepositoryImpl(mockClient);
  });

  group('SholatRepositoryImpl', () {

    group('getPrayerSchedule', () {
      test('should return a PrayerSchedule when the response is 200 and status is true', () async {
        // Arrange
        final cityId = '1301';
        final date = DateTime(2026, 2, 28);
        final responseBody = {
          "status": true,
          "data": {
            "id": "1301",
            "lokasi": "KOTA JAKARTA",
            "daerah": "DKI JAKARTA",
            "koordinat": {"lat": -6.17539, "lon": 106.82715, "lintang": "6° 10' 31.4\" S", "bujur": "106° 49' 37.74\" E"},
            "jadwal": {
              "tanggal": "Selasa, 28 Feb 2026",
              "imsak": "04:35",
              "subuh": "04:45",
              "terbit": "05:57",
              "dhuha": "06:24",
              "dzuhur": "12:10",
              "ashar": "15:15",
              "maghrib": "18:15",
              "isya": "19:25"
            }
          }
        };
        when(mockClient.get(any)).thenAnswer((_) async => http.Response(jsonEncode(responseBody), 200));

        // Act
        // We provide a full 30 days list to match getMonthlyPrayerSchedule logic.
        final result = await repository.getMonthlyPrayerSchedule(
          locationName: cityId,
          latitude: 0.0,
          longitude: 0.0,
          year: date.year,
          month: date.month,
        );

        // Assert
        expect(result, isA<PrayerSchedule>());
        expect(result, isA<List<PrayerSchedule>>());
        expect(result.first.location, 'KOTA JAKARTA');
      });
    });
  });
}
