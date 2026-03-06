import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../../domain/entities/surah.dart';
import '../../domain/entities/surah_detail.dart';
import '../../domain/entities/verse_words.dart';
import '../../domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  // Cache for already-fetched surah details
  final Map<int, SurahDetail> _cache = {};
  
  // Cache for word-by-word data
  final Map<int, List<VerseWords>> _wordCache = {};

  @override
  Future<List<Surah>> getSurahs() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/surahs.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Surah.fromJson(json)).toList();
  }

  @override
  Future<SurahDetail> getSurahDetail(int surahNumber) async {
    // Return from cache if available
    if (_cache.containsKey(surahNumber)) {
      return _cache[surahNumber]!;
    }

    // Load from local assets
    try {
      final String jsonString = await rootBundle
          .loadString('assets/data/surahs/$surahNumber.json');
      
      // Validate it's actual JSON
      if (jsonString.trim().startsWith('{')) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        
        // --- Add preBismillah field dynamically ---
        if (jsonMap['number'] == 1 || jsonMap['number'] == 9) {
          jsonMap['preBismillah'] = false;
        } else {
          jsonMap['preBismillah'] = true;
        }
        // -----------------------------------------

        if (jsonMap.containsKey('verses')) {
          final detail = SurahDetail.fromJson(jsonMap);
          _cache[surahNumber] = detail;
          return detail;
        }
      }
      throw Exception('Data surah tidak valid');
    } catch (e) {
      throw Exception('Gagal memuat Surah $surahNumber dari memori lokal. Silakan install ulang aplikasi.');
    }
  }

  @override
  Future<List<VerseWords>> getWordByWordTranslation(int surahNumber) async {
    if (_wordCache.containsKey(surahNumber)) {
      return _wordCache[surahNumber]!;
    }

    try {
      final response = await http.get(Uri.parse(
          'https://api.quran.com/api/v4/verses/by_chapter/$surahNumber?language=id&words=true&word_fields=text_uthmani,translation'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        final List<dynamic> versesJson = jsonMap['verses'];
        final words = versesJson.map((v) => VerseWords.fromJson(v)).toList();
        _wordCache[surahNumber] = words;
        return words;
      } else {
        throw Exception('Gagal mengambil data terjemahan per kata.');
      }
    } catch (e) {
      throw Exception('Tidak ada koneksi internet atau server gangguan.');
    }
  }
}
