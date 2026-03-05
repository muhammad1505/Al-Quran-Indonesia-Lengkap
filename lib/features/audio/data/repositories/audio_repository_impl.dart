import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/qori.dart';
import '../../domain/repositories/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final Dio _dio = Dio();
  // Hardcoded 8 popular Qaris based on standard everyayah / equran CD structures
  final List<Qori> _qoris = const [
    Qori(
      id: 1,
      name: 'Mishary Rashid Alafasy',
      style: 'Murattal',
      serverIdentifier: 'Alafasy_128kbps',
    ),
    Qori(
      id: 2,
      name: 'Abdul Basit (Murattal)',
      style: 'Murattal',
      serverIdentifier: 'Abdul_Basit_Murattal_192kbps',
    ),
    Qori(
      id: 3,
      name: 'Abdurrahmaan As-Sudais',
      style: 'Murattal',
      serverIdentifier: 'Abdurrahmaan_As-Sudais_192kbps',
    ),
    Qori(
      id: 4,
      name: 'Abu Bakr Ash-Shaatree',
      style: 'Murattal',
      serverIdentifier: 'Abu_Bakr_Ash-Shaatree_128kbps',
    ),
    Qori(
      id: 5,
      name: 'Hani Rifai',
      style: 'Murattal',
      serverIdentifier: 'Hani_Rifai_192kbps',
    ),
    Qori(
      id: 6,
      name: 'Husary (Murattal)',
      style: 'Murattal',
      serverIdentifier: 'Husary_128kbps',
    ),
    Qori(
      id: 7,
      name: 'Saood Ash-Shuraym',
      style: 'Murattal',
      serverIdentifier: 'Saood_ash-Shuraym_128kbps',
    ),
    Qori(
      id: 8,
      name: 'Maher Al Muaiqly',
      style: 'Murattal',
      serverIdentifier: 'MaherAlMuaiqly128kbps', // specific identifier from EveryAyah
    ),
  ];

  @override
  Future<List<Qori>> getAvailableQoris() async {
    // Return mock data instantaneously for this implementation
    return _qoris;
  }

  @override
  String getSurahAudioUrl(Qori qori, int surahNumber) {
    // Example endpoint from EveryAyah: https://everyayah.com/data/Alafasy_128kbps/001.mp3
    final formattedSurah = surahNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/${qori.serverIdentifier}/$formattedSurah.mp3';
  }

  @override
  String getAyatAudioUrl(Qori qori, int surahNumber, int ayatNumber) {
    // Example endpoint from EveryAyah: https://everyayah.com/data/Alafasy_128kbps/001001.mp3
    final formattedSurah = surahNumber.toString().padLeft(3, '0');
    final formattedAyat = ayatNumber.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/${qori.serverIdentifier}/$formattedSurah$formattedAyat.mp3';
  }

  Future<String> _getDownloadDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final localPath = '${dir.path}/audio_murattal';
    final savedDir = Directory(localPath);
    if (!await savedDir.exists()) {
      await savedDir.create(recursive: true);
    }
    return localPath;
  }

  String _getAyatFileName(Qori qori, int surahNumber, int ayatNumber) {
    final formattedSurah = surahNumber.toString().padLeft(3, '0');
    final formattedAyat = ayatNumber.toString().padLeft(3, '0');
    return '${qori.serverIdentifier}_$formattedSurah$formattedAyat.mp3';
  }

  @override
  Future<bool> isSurahDownloaded(Qori qori, int surahNumber, int totalAyats) async {
    final dir = await _getDownloadDirectory();
    for (int i = 1; i <= totalAyats; i++) {
      final file = File('$dir/${_getAyatFileName(qori, surahNumber, i)}');
      if (!await file.exists()) return false;
    }
    return true;
  }

  @override
  Future<String?> getLocalAyatPath(Qori qori, int surahNumber, int ayatNumber) async {
    final dir = await _getDownloadDirectory();
    final file = File('$dir/${_getAyatFileName(qori, surahNumber, ayatNumber)}');
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  @override
  Future<void> downloadSurah(
    Qori qori,
    int surahNumber,
    int totalAyats, {
    void Function(int completed, int total)? onProgress,
  }) async {
    final dir = await _getDownloadDirectory();
    int completed = 0;

    // Use a sequential approach to avoid overwhelming the server or socket limits
    for (int i = 1; i <= totalAyats; i++) {
      final filePath = '$dir/${_getAyatFileName(qori, surahNumber, i)}';
      final file = File(filePath);

      if (!await file.exists()) {
        final url = getAyatAudioUrl(qori, surahNumber, i);
        try {
          await _dio.download(url, filePath);
        } catch (e) {
          // If a download fails, we shouldn't necessarily crash the whole batch, but we can log it
          // Or throw to let the UI know it failed
          rethrow;
        }
      }

      completed++;
      if (onProgress != null) {
        onProgress(completed, totalAyats);
      }
    }
  }

  @override
  Future<void> deleteSurah(Qori qori, int surahNumber, int totalAyats) async {
    final dir = await _getDownloadDirectory();
    for (int i = 1; i <= totalAyats; i++) {
      final file = File('$dir/${_getAyatFileName(qori, surahNumber, i)}');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}
