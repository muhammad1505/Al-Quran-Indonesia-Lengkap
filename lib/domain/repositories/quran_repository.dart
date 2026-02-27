import '../entities/surah.dart';
import '../entities/surah_detail.dart';

abstract class QuranRepository {
  Future<List<Surah>> getSurahs();
  Future<SurahDetail> getSurahDetail(int surahNumber);
}
