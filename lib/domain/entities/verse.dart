class Verse {
  final int number;
  final String text;
  final String translationEn;

  Verse({
    required this.number,
    required this.text,
    required this.translationEn,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'],
      text: json['text'],
      translationEn: json['translation_en'],
    );
  }
}
