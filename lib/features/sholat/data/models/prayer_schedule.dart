import 'package:hijri/hijri_calendar.dart';

class PrayerSchedule {
  final String location;
  final String date;
  final String hijriDate;
  final Jadwal jadwal;

  PrayerSchedule({
    required this.location,
    required this.date,
    required this.hijriDate,
    required this.jadwal,
  });

  /// Parse from Aladhan API response
  /// The `data` object contains `timings`, `date`, and `meta`.
  factory PrayerSchedule.fromAladhanJson(Map<String, dynamic> data, String locationName) {
    final timings = data['timings'] as Map<String, dynamic>;
    final dateInfo = data['date'] as Map<String, dynamic>;
    
    // Gregorian date
    final gregorian = dateInfo['gregorian'] as Map<String, dynamic>;
    final gregDate = gregorian['date'] as String; // "DD-MM-YYYY"
    final gregDay = gregorian['weekday']?['en'] as String? ?? '';
    
    // Hijri date
    final hijri = dateInfo['hijri'] as Map<String, dynamic>;
    final hijriDay = hijri['day'] as String? ?? '';
    final hijriMonth = (hijri['month'] as Map<String, dynamic>?)?['en'] as String? ?? '';
    final hijriYear = hijri['year'] as String? ?? '';
    
    // Translate day name
    String displayDate = '${_translateDay(gregDay)}, $gregDate';
    String hijriInfo = '$hijriDay $hijriMonth $hijriYear H';

    // Extract times — Aladhan returns "HH:mm (TZ)" format, strip timezone
    String cleanTime(String? raw) {
      if (raw == null) return '--:--';
      // Remove timezone info like " (WIB)" or " (+07)"
      final idx = raw.indexOf(' (');
      return idx > 0 ? raw.substring(0, idx) : raw;
    }

    return PrayerSchedule(
      location: locationName,
      date: displayDate,
      hijriDate: hijriInfo,
      jadwal: Jadwal(
        tanggal: displayDate,
        imsak: cleanTime(timings['Imsak']?.toString()),
        subuh: cleanTime(timings['Fajr']?.toString()),
        terbit: cleanTime(timings['Sunrise']?.toString()),
        dhuha: _calculateDhuha(cleanTime(timings['Sunrise']?.toString())),
        dzuhur: cleanTime(timings['Dhuhr']?.toString()),
        ashar: cleanTime(timings['Asr']?.toString()),
        maghrib: cleanTime(timings['Maghrib']?.toString()),
        isya: cleanTime(timings['Isha']?.toString()),
      ),
    );
  }

  /// Parse from myquran API (legacy, kept for reference)
  factory PrayerSchedule.fromMyQuranJson(Map<String, dynamic> jsonData, String locationName) {
    String displayDate = jsonData['tanggal'] as String;
    
    String hijriInfo = "- H";
    try {
      if (jsonData.containsKey('date')) {
        final dateStr = jsonData['date'] as String;
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          final hijri = HijriCalendar.fromDate(DateTime(year, month, day));
          hijriInfo = '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} H';
        }
      }
    } catch (_) {}

    return PrayerSchedule(
      location: locationName,
      date: displayDate,
      hijriDate: hijriInfo,
      jadwal: Jadwal(
        tanggal: displayDate,
        imsak: jsonData['imsak'] as String,
        subuh: jsonData['subuh'] as String,
        terbit: jsonData['terbit'] as String,
        dhuha: jsonData['dhuha'] as String,
        dzuhur: jsonData['dzuhur'] as String,
        ashar: jsonData['ashar'] as String,
        maghrib: jsonData['maghrib'] as String,
        isya: jsonData['isya'] as String,
      ),
    );
  }

  static String _translateDay(String englishDay) {
    switch (englishDay.toLowerCase()) {
      case 'monday': return 'Senin';
      case 'tuesday': return 'Selasa';
      case 'wednesday': return 'Rabu';
      case 'thursday': return 'Kamis';
      case 'friday': return 'Jum\'at';
      case 'saturday': return 'Sabtu';
      case 'sunday': return 'Minggu';
      default: return englishDay;
    }
  }

  /// Dhuha is typically ~15 min after sunrise
  static String _calculateDhuha(String sunriseTime) {
    try {
      final parts = sunriseTime.split(':');
      if (parts.length == 2) {
        var hour = int.parse(parts[0]);
        var min = int.parse(parts[1]) + 15;
        if (min >= 60) {
          hour += 1;
          min -= 60;
        }
        return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
      }
    } catch (_) {}
    return sunriseTime;
  }

  /// Add minutes to a time string "HH:MM"
  static String addMinutes(String time, int minutes) {
    final parts = time.split(':');
    if (parts.length != 2) return time;
    var hour = int.tryParse(parts[0]) ?? 0;
    var min = int.tryParse(parts[1]) ?? 0;
    min += minutes;
    if (min >= 60) {
      hour += min ~/ 60;
      min = min % 60;
    }
    if (min < 0) {
      hour -= 1;
      min += 60;
    }
    return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
  }
}

class Jadwal {
  final String tanggal;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  Jadwal({
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });
}
