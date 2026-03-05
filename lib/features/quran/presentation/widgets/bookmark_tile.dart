import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/features/quran/presentation/pages/surah_page_view.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';

class BookmarkTile extends ConsumerWidget {
  final String bookmarkId;

  const BookmarkTile({super.key, required this.bookmarkId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    try {
      final parts = bookmarkId.split(':');
      final surahNumber = int.parse(parts[0]);
      final ayahNumber = int.parse(parts[1]);

      final surahDetailAsync = ref.watch(surahDetailProvider(surahNumber));

      return surahDetailAsync.when(
        data: (detail) {
          final verse = detail.verses.firstWhere((v) => v.number == ayahNumber);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahPageView(
                        initialSurahNumber: surahNumber,
                        initialAyahNumber: ayahNumber,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$surahNumber:$ayahNumber',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accentDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${detail.transliterationEn}, Ayat $ayahNumber',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                          const Icon(Icons.bookmark_rounded,
                              color: AppColors.accent, size: 22),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        verse.text,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.amiri(
                          fontSize: 20,
                          height: 1.8,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.3)),
                      const SizedBox(height: 6),
                      Text(
                        verse.translationEn,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: theme.textTheme.bodyMedium?.color,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.error_outline, color: AppColors.error),
              title: Text('Error: $bookmarkId'),
            ),
          ),
        ),
      );
    } catch (e) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.error_outline, color: AppColors.error),
            title: Text('Invalid: $bookmarkId'),
          ),
        ),
      );
    }
  }
}
