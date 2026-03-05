class WordTranslation {
  final int id;
  final int position;
  final String textUthmani;
  final String? translationText;
  final String type; // e.g 'word' or 'end'

  const WordTranslation({
    required this.id,
    required this.position,
    required this.textUthmani,
    this.translationText,
    required this.type,
  });

  factory WordTranslation.fromJson(Map<String, dynamic> json) {
    return WordTranslation(
      id: json['id'] as int,
      position: json['position'] as int,
      textUthmani: json['text_uthmani'] as String,
      translationText: json['translation'] != null ? json['translation']['text'] as String : null,
      type: json['char_type_name'] as String,
    );
  }
}

class VerseWords {
  final int id;
  final int verseNumber;
  final String verseKey;
  final List<WordTranslation> words;

  const VerseWords({
    required this.id,
    required this.verseNumber,
    required this.verseKey,
    required this.words,
  });

  factory VerseWords.fromJson(Map<String, dynamic> json) {
    return VerseWords(
      id: json['id'] as int,
      verseNumber: json['verse_number'] as int,
      verseKey: json['verse_key'] as String,
      words: (json['words'] as List<dynamic>)
          .map((w) => WordTranslation.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }
}
