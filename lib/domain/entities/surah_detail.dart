import 'verse.dart';

class SurahDetail {
  final int number;
  final String name;
  final String transliterationEn;
  final String translationEn;
  final int totalVerses;
  final String revelationType;
  final List<Verse> verses;

  SurahDetail({
    required this.number,
    required this.name,
    required this.transliterationEn,
    required this.translationEn,
    required this.totalVerses,
    required this.revelationType,
    required this.verses,
  });

  factory SurahDetail.fromJson(Map<String, dynamic> json) {
    var versesList = json['verses'] as List;
    List<Verse> verseObjects = versesList.map((v) => Verse.fromJson(v)).toList();

    return SurahDetail(
      number: json['number'],
      name: json['name'],
      transliterationEn: json['transliteration_en'],
      translationEn: json['translation_en'],
      totalVerses: json['total_verses'],
      revelationType: json['revelation_type'],
      verses: verseObjects,
    );
  }
}
