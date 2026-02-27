import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/surah.dart';
import '../../domain/entities/surah_detail.dart';
import '../../domain/repositories/quran_repository.dart';

class QuranRepositoryImpl implements QuranRepository {
  @override
  Future<List<Surah>> getSurahs() async {
    // Load the JSON string from the assets file
    final String jsonString = await rootBundle.loadString('assets/data/surahs.json');
    
    // Decode the JSON string into a List of dynamic objects
    final List<dynamic> jsonList = json.decode(jsonString);
    
    // Map the list of dynamic objects to a List of Surah objects
    return jsonList.map((json) => Surah.fromJson(json)).toList();
  }

  @override
  Future<SurahDetail> getSurahDetail(int surahNumber) async {
    // Load the JSON string from the specific surah file in assets
    final String jsonString = await rootBundle.loadString('assets/data/surahs/$surahNumber.json');
    
    // Decode the JSON string into a Map
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    
    // Map the JSON map to a SurahDetail object
    return SurahDetail.fromJson(jsonMap);
  }
}
