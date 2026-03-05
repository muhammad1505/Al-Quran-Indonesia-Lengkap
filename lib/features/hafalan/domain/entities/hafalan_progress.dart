import 'dart:convert';

enum HafalanStatus { belum, proses, selesai }

class HafalanProgress {
  final String id;
  final int surahNumber;
  final String surahName;
  final int totalAyat;
  final int ayatFrom;
  final int ayatTo;
  final HafalanStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? notes;

  HafalanProgress({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.totalAyat,
    required this.ayatFrom,
    required this.ayatTo,
    this.status = HafalanStatus.belum,
    DateTime? createdAt,
    this.completedAt,
    this.notes,
  }) : createdAt = createdAt ?? DateTime.now();

  int get progress {
    if (status == HafalanStatus.selesai) return 100;
    if (status == HafalanStatus.belum) return 0;
    final range = ayatTo - ayatFrom + 1;
    return range > 0 ? ((range / totalAyat) * 100).clamp(0, 100).toInt() : 0;
  }

  HafalanProgress copyWith({
    HafalanStatus? status,
    int? ayatFrom,
    int? ayatTo,
    DateTime? completedAt,
    String? notes,
  }) {
    return HafalanProgress(
      id: id,
      surahNumber: surahNumber,
      surahName: surahName,
      totalAyat: totalAyat,
      ayatFrom: ayatFrom ?? this.ayatFrom,
      ayatTo: ayatTo ?? this.ayatTo,
      status: status ?? this.status,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'surahNumber': surahNumber,
        'surahName': surahName,
        'totalAyat': totalAyat,
        'ayatFrom': ayatFrom,
        'ayatTo': ayatTo,
        'status': status.index,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
        'notes': notes,
      };

  factory HafalanProgress.fromJson(Map<String, dynamic> json) {
    return HafalanProgress(
      id: json['id'] as String,
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String,
      totalAyat: json['totalAyat'] as int,
      ayatFrom: json['ayatFrom'] as int,
      ayatTo: json['ayatTo'] as int,
      status: HafalanStatus.values[json['status'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }

  static String encodeList(List<HafalanProgress> list) =>
      jsonEncode(list.map((e) => e.toJson()).toList());

  static List<HafalanProgress> decodeList(String jsonStr) {
    final list = jsonDecode(jsonStr) as List;
    return list
        .map((e) => HafalanProgress.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
