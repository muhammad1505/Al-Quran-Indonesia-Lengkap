class Doa {
  final String title;
  final String arabic;
  final String latin;
  final String translation;
  final String? notes;

  Doa({
    required this.title,
    required this.arabic,
    required this.latin,
    required this.translation,
    this.notes,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      title: json['judul'] as String,
      arabic: json['arab'] as String,
      latin: json['latin'] as String,
      translation: json['arti'] as String,
      notes: json['footnote'] as String?,
    );
  }
}
