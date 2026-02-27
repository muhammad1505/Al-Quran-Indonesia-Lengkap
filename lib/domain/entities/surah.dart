class Surah {
  final int number;
  final String name;
  final String transliterationEn;
  final String translationEn;
  final int totalVerses;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.transliterationEn,
    required this.translationEn,
    required this.totalVerses,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'],
      name: json['name'],
      transliterationEn: json['transliteration_en'],
      translationEn: json['translation_en'],
      totalVerses: json['total_verses'],
      revelationType: json['revelation_type'],
    );
  }
}
