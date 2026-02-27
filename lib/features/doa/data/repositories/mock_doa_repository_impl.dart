import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran_app/features/doa/domain/entities/doa.dart';
import 'package:quran_app/features/doa/domain/repositories/doa_repository.dart';

class MockDoaRepositoryImpl implements DoaRepository {
  Future<List<Doa>> _getList(String assetPath) async {
    final String response = await rootBundle.loadString(assetPath);
    final List<dynamic> data = await json.decode(response);
    return data.map((json) => Doa.fromJson(json)).toList();
  }

  @override
  Future<List<Doa>> getDoaHarian() {
    return _getList('assets/data/doa_harian.json');
  }

  @override
  Future<List<Doa>> getDzikirPagi() {
    return _getList('assets/data/dzikir_pagi.json');
  }

  @override
  Future<List<Doa>> getDzikirPetang() {
    return _getList('assets/data/dzikir_petang.json');
  }
}
