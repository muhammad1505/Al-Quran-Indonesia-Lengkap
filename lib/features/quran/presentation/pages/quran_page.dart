import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/features/quran/presentation/pages/bookmarks_page.dart';
import 'package:quran_app/features/quran/presentation/pages/surah_detail_page.dart';
import 'package:quran_app/features/quran/presentation/widgets/last_read_card.dart';
import 'package:quran_app/features/quran/presentation/widgets/surah_list_tile.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';
import 'package:quran_app/providers/app_providers.dart';

class QuranPage extends ConsumerStatefulWidget {
  const QuranPage({super.key});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSurahsAsync = ref.watch(filteredSurahsProvider);
    final lastReadAsync = ref.watch(lastReadProvider);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).update(query);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).update('');
                  },
                ),
                hintText: 'Search Surah...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarksPage()),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: CustomScrollView(
          slivers: [
            // Last Read Card (only shows if not searching)
            if (_searchController.text.isEmpty)
              lastReadAsync.when(
                data: (lastReadData) {
                  if (lastReadData == null) {
                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  }
                  return SliverToBoxAdapter(
                    child: LastReadCard(
                      surahName: lastReadData['surahName'] as String,
                      ayahNumber: lastReadData['ayahNumber'] as int,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahDetailPage(
                              surahNumber: lastReadData['surahNumber'] as int,
                              surahName: lastReadData['surahName'] as String,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),

            // Surah List
            filteredSurahsAsync.when(
              data: (surahs) {
                if (surahs.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No surahs found.')),
                  );
                }
                return SliverList.builder(
                  itemCount: surahs.length,
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    return SurahListTile(
                      surah: surah,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurahDetailPage(
                              surahNumber: surah.number,
                              surahName: surah.transliterationEn,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => SliverFillRemaining(
                child: Center(child: Text('Failed to load surahs: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
