import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/features/quran/presentation/widgets/surah_detail_header.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';
import 'package:quran_app/providers/app_providers.dart';

class SurahDetailPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;

  const SurahDetailPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
  });

  @override
  ConsumerState<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends ConsumerState<SurahDetailPage> {
  @override
  void dispose() {
    // Save the last read position when the user leaves the page.
    ref.read(localStorageServiceProvider).saveLastRead(
          surahNumber: widget.surahNumber,
          surahName: widget.surahName,
          ayahNumber: 1, // For simplicity, we save the first ayah.
        );
    // Invalidate the provider so the QuranPage will refetch the last read data.
    ref.invalidate(lastReadProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahDetailAsync = ref.watch(surahDetailProvider(widget.surahNumber));
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      body: surahDetailAsync.when(
        data: (detail) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.surahName, style: GoogleFonts.poppins()),
                  background: SurahDetailHeader(surahDetail: detail),
                ),
              ),
              bookmarksAsync.when(
                data: (bookmarks) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final verse = detail.verses[index];
                      final bookmarkId = '${detail.number}:${verse.number}';
                      final isBookmarked = bookmarks.contains(bookmarkId);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    bookmarkId,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                                    onPressed: () {
                                      if (isBookmarked) {
                                        ref.read(bookmarksProvider.notifier).remove(bookmarkId);
                                      } else {
                                        ref.read(bookmarksProvider.notifier).add(bookmarkId);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                verse.text,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.amiri(
                                  fontSize: 24,
                                  height: 1.8,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                verse.translationEn,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: detail.verses.length,
                  ),
                ),
                loading: () => const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),
                error: (e, s) => SliverToBoxAdapter(child: Center(child: Text('Error loading bookmarks: $e'))),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Failed to load surah detail. Make sure the JSON file for surah ${widget.surahNumber} exists in assets/data/surahs/.\n\nError: $error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
