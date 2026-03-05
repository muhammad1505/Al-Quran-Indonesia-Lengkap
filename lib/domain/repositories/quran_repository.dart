import '../entities/surah.dart';
import '../entities/surah_detail.dart';
import '../entities/verse_words.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahs();
  Future<SurahDetail> getSurahDetail(int surahNumber);
  Future<List<VerseWords>> getWordByWordTranslation(int surahNumber);
}
