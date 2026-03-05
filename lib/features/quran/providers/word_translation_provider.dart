import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/verse_words.dart';
import 'surah_providers.dart';

// State to hold whether the word-by-word feature is toggled ON or OFF
final wordByWordEnabledProvider = StateProvider<bool>((ref) => false);

// FutureProvider to fetch and cache the word translation data per Surah
final wordTranslationProvider = FutureProvider.family<List<VerseWords>, int>((ref, surahNumber) async {
  final repository = ref.watch(quranRepositoryProvider);
  return await repository.getWordByWordTranslation(surahNumber);
});
