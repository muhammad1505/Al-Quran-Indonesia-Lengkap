import 'package:quran_app/domain/entities/surah_detail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/repositories/quran_repository_impl.dart';
import '../../../domain/entities/surah.dart';
import '../../../domain/repositories/quran_repository.dart';

part 'surah_providers.g.dart';

// 1. Repository Provider
@riverpod
QuranRepository quranRepository(QuranRepositoryRef ref) {
  return QuranRepositoryImpl();
}

// 2. Surah List Provider
@riverpod
Future<List<Surah>> surahList(SurahListRef ref) {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getSurahs();
}

// 3. Surah Detail Provider (Family)
@riverpod
Future<SurahDetail> surahDetail(SurahDetailRef ref, int surahNumber) {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getSurahDetail(surahNumber);
}

// 4. Search Query Provider
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }
}

// 5. Filtered Surahs Provider
@riverpod
Future<List<Surah>> filteredSurahs(FilteredSurahsRef ref) async {
  // Get the search query and the full list of surahs
  final query = ref.watch(searchQueryProvider);
  final surahs = await ref.watch(surahListProvider.future);

  // If the query is empty, return the full list
  if (query.isEmpty) {
    return surahs;
  }

  // Otherwise, filter the list
  return surahs
      .where((surah) =>
          surah.transliterationEn.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
