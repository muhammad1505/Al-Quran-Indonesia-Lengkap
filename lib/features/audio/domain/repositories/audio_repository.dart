import '../entities/qori.dart';

abstract class AudioRepository {
  /// Fetches the list of available Qoris (Reciters).
  Future<List<Qori>> getAvailableQoris();

  /// Gets the MP3 URL for a specific Surah (full chapter) by a given Qori.
  String getSurahAudioUrl(Qori qori, int surahNumber);

  /// Gets the MP3 URL for a specific Ayat (verse) by a given Qori.
  String getAyatAudioUrl(Qori qori, int surahNumber, int ayatNumber);

  /// Checks if all Ayats for a Surah are downloaded.
  Future<bool> isSurahDownloaded(Qori qori, int surahNumber, int totalAyats);

  /// Gets the local path of the downloaded Ayat audio, or null if not downloaded.
  Future<String?> getLocalAyatPath(Qori qori, int surahNumber, int ayatNumber);

  /// Downloads all Ayats for a Surah iteratively for offline listening.
  Future<void> downloadSurah(
    Qori qori, 
    int surahNumber, 
    int totalAyats, {
    void Function(int completed, int total)? onProgress,
  });

  /// Deletes all downloaded Ayat audio files for a Surah.
  Future<void> deleteSurah(Qori qori, int surahNumber, int totalAyats);
}
