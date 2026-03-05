class Verse {
  final int number;
  final String text;
  final String translationEn;
  final String? transliteration;
  final String? tafsirJalalain;
  final String? textIndopak;

  Verse({
    required this.number,
    required this.text,
    required this.translationEn,
    this.transliteration,
    this.tafsirJalalain,
    this.textIndopak,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      number: json['number'],
      text: json['text'],
      translationEn: json['translation_en'],
      transliteration: json['transliteration'],
      tafsirJalalain: json['tafsir_jalalain'],
      textIndopak: json['text_indopak'],
    );
  }
}
