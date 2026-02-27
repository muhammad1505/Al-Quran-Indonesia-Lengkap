import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:quran_app/features/doa/data/repositories/mock_doa_repository_impl.dart';
import 'package:quran_app/features/doa/domain/entities/doa.dart';
import 'package:quran_app/features/doa/domain/repositories/doa_repository.dart';

part 'doa_providers.g.dart';

@riverpod
DoaRepository doaRepository(DoaRepositoryRef ref) {
  return MockDoaRepositoryImpl();
}

@riverpod
Future<List<Doa>> doaHarian(DoaHarianRef ref) {
  return ref.watch(doaRepositoryProvider).getDoaHarian();
}

@riverpod
Future<List<Doa>> dzikirPagi(DzikirPagiRef ref) {
  return ref.watch(doaRepositoryProvider).getDzikirPagi();
}

@riverpod
Future<List<Doa>> dzikirPetang(DzikirPetangRef ref) {
  return ref.watch(doaRepositoryProvider).getDzikirPetang();
}
