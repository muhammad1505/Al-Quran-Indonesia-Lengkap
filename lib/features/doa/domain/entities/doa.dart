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
      title: (json['judul'] ?? json['title'] ?? '') as String,
      arabic: (json['arab'] ?? json['arabic'] ?? '') as String,
      latin: (json['latin'] ?? '') as String,
      translation: (json['arti'] ?? json['translation'] ?? '') as String,
      notes: (json['footnote'] ?? json['notes']) as String?,
    );
  }
}
