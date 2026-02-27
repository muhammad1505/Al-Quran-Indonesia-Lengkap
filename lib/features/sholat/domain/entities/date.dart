class PrayerDate {
  final String readable;
  final String hijriMonth;
  final String hijriYear;

  PrayerDate({
    required this.readable,
    required this.hijriMonth,
    required this.hijriYear,
  });

  factory PrayerDate.fromJson(Map<String, dynamic> json) {
    return PrayerDate(
      readable: json['readable'] as String,
      hijriMonth: json['hijri']['month']['en'] as String,
      hijriYear: json['hijri']['year'] as String,
    );
  }
}
