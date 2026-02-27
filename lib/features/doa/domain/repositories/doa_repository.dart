import 'package:quran_app/features/doa/domain/entities/doa.dart';

abstract class DoaRepository {
  Future<List<Doa>> getDoaHarian();
  Future<List<Doa>> getDzikirPagi();
  Future<List<Doa>> getDzikirPetang();
}
