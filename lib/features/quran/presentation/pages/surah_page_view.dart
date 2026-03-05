import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/features/quran/presentation/pages/surah_detail_page.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';

class SurahPageView extends ConsumerStatefulWidget {
  final int initialSurahNumber;
  final int? initialAyahNumber;

  const SurahPageView({
    super.key,
    required this.initialSurahNumber,
    this.initialAyahNumber,
  });

  @override
  ConsumerState<SurahPageView> createState() => _SurahPageViewState();
}

class _SurahPageViewState extends ConsumerState<SurahPageView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // surah number is 1-based, PageView index is 0-based
    _pageController = PageController(initialPage: widget.initialSurahNumber - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      body: surahsAsync.when(
        data: (surahs) {
          if (surahs.isEmpty) {
            return const Center(child: Text('Tidak ada data surah.'));
          }
          return PageView.builder(
            controller: _pageController,
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final surah = surahs[index];
              return SurahDetailPage(
                key: ValueKey(surah.number),
                surahNumber: surah.number,
                surahName: surah.transliterationEn,
                // Only pass initialAyahNumber to the initial surah
                initialAyahNumber: widget.initialSurahNumber == surah.number
                    ? widget.initialAyahNumber
                    : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error memuat Al-Quran')),
      ),
    );
  }
}
