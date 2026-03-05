import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/core/providers/settings_provider.dart';
import 'package:quran_app/features/quran/presentation/widgets/surah_detail_header.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';
import 'package:quran_app/features/tajwid/domain/entities/tajweed_rule.dart';
import 'package:quran_app/features/tajwid/domain/tajweed.dart';
import 'package:quran_app/providers/app_providers.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:quran_app/features/audio/presentation/providers/audio_player_provider.dart';
import 'package:quran_app/features/audio/presentation/widgets/audio_control_bar.dart';
import 'package:quran_app/features/quran/providers/word_translation_provider.dart';
import 'package:quran_app/domain/entities/verse_words.dart';

class SurahDetailPage extends ConsumerStatefulWidget {
  final int surahNumber;
  final String surahName;
  final int? initialAyahNumber;
  final bool singleAyahMode;

  const SurahDetailPage({
    super.key,
    required this.surahNumber,
    required this.surahName,
    this.initialAyahNumber,
    this.singleAyahMode = false,
  });

  @override
  ConsumerState<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends ConsumerState<SurahDetailPage> {
  late AutoScrollController _scrollController;
  int _lastVisibleAyah = 1;
  int? _highlightedAyah;

  @override
  void initState() {
    super.initState();
    _lastVisibleAyah = widget.initialAyahNumber ?? 1;
    _scrollController = AutoScrollController();
    if (widget.initialAyahNumber != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToIndex(widget.initialAyahNumber! - 1);
      });
    }
  }

  void _scrollToIndex(int index) {
    _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _copyAyah(String arabic, String translation, int verseNum) {
    final text = '$arabic\n\n'
        '${widget.surahName} : $verseNum\n'
        '$translation';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ayat $verseNum berhasil disalin'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareAyah(String arabic, String translation, int verseNum) {
    final text = '$arabic\n\n'
        '${widget.surahName} : $verseNum\n'
        '$translation';
    // ignore: deprecated_member_use
    Share.share(text);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  TextSpan _buildVerseText(
    String text,
    int ayahNumber,
    int surahNumber,
    bool isTajwidMode,
  ) {
    final theme = Theme.of(context);

    if (!isTajwidMode) {
      return TextSpan(
        text: text,
        style: GoogleFonts.amiri(
          fontSize: 28,
          height: 2.2,
          color: theme.textTheme.bodyLarge?.color,
        ),
      );
    }

    final tokens = tokenize(text);
    if (tokens.isEmpty) {
      return TextSpan(
        text: text,
        style: GoogleFonts.amiri(
          fontSize: 28,
          height: 2.2,
          color: theme.textTheme.bodyLarge?.color,
        ),
      );
    }

    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (final token in tokens) {
      if (token.start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, token.start),
          style: GoogleFonts.amiri(
            fontSize: 28,
            height: 2.2,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ));
      }

      spans.add(TextSpan(
        text: text.substring(token.start, token.end),
        style: GoogleFonts.amiri(
          fontSize: 28,
          height: 2.2,
          color: _getColorForTajweedRule(token.subrule.type),
          fontWeight: FontWeight.bold,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            _showTajwidRule(context, token.rule.name, token.rule.description);
          },
      ));

      currentIndex = token.end;
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: GoogleFonts.amiri(
          fontSize: 28,
          height: 2.2,
          color: theme.textTheme.bodyLarge?.color,
        ),
      ));
    }

    return TextSpan(children: spans);
  }

  Color _getColorForTajweedRule(TajweedRuleType type) {
    switch (type) {
      case TajweedRuleType.ghunna:
        return AppColors.tajwidGhunnah;
      case TajweedRuleType.ikhfaa:
        return AppColors.tajwidIkhfa;
      case TajweedRuleType.idgham:
        return AppColors.tajwidIdghamBighunnah;
      case TajweedRuleType.iqlab:
        return AppColors.tajwidIqlab;
      case TajweedRuleType.qalqala:
        return AppColors.tajwidQalqalah;
      case TajweedRuleType.madd:
        return AppColors.tajwidMad;
      case TajweedRuleType.izhar:
        return AppColors.tajwidIzhar;
    }
  }

  void _showTajwidRule(BuildContext context, String title, String explanation) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                explanation,
                style: GoogleFonts.poppins(fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWordByWordVerse(VerseWords verseWords, ThemeData theme) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 16.0,
      runSpacing: 16.0,
      children: verseWords.words.map((word) {
        if (word.type == 'end') {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  word.textUthmani,
                  style: GoogleFonts.amiri(
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              word.textUthmani,
              style: GoogleFonts.amiri(
                fontSize: 28,
                height: 1.5,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 4),
            if (word.translationText != null)
              Text(
                word.translationText!,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: theme.textTheme.bodySmall?.color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final surahDetailAsync =
        ref.watch(surahDetailProvider(widget.surahNumber));
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final settings = ref.watch(settingsProvider);
    final isTajwidMode = settings.isTajwidMode;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isWordByWordEnabled = ref.watch(wordByWordEnabledProvider);
    final wordTranslationsAsync = isWordByWordEnabled 
        ? ref.watch(wordTranslationProvider(widget.surahNumber)) 
        : const AsyncValue<List<VerseWords>>.loading();

    return PopScope(
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (didPop) {
          ref.read(localStorageServiceProvider).saveLastRead(
                surahNumber: widget.surahNumber,
                surahName: widget.surahName,
                ayahNumber: _lastVisibleAyah,
              );
          ref.invalidate(lastReadProvider);
        }
      },
      child: Scaffold(
        body: surahDetailAsync.when(
          data: (detail) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: Text(widget.surahName,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold)),
                    centerTitle: true,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Kata per Kata',
                              style: GoogleFonts.poppins(
                                  fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                            Switch(
                              value: isWordByWordEnabled,
                              onChanged: (val) {
                                ref.read(wordByWordEnabledProvider.notifier).state = val;
                              },
                              activeTrackColor: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Surah Info Card
                  SliverToBoxAdapter(
                    child: SurahDetailHeader(surahDetail: detail),
                  ),
                bookmarksAsync.when(
                  data: (bookmarks) {
                    final visibleVerses = widget.singleAyahMode && widget.initialAyahNumber != null
                        ? detail.verses.where((v) => v.number == widget.initialAyahNumber).toList()
                        : detail.verses;

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final verse = visibleVerses[index];
                        final bookmarkId = '${detail.number}:${verse.number}';
                        final isBookmarked = bookmarks.contains(bookmarkId);
                        final isHighlighted = _highlightedAyah == verse.number;

                        return VisibilityDetector(
                          key: Key('$bookmarkId-vis'),
                          onVisibilityChanged: (info) {
                            if (info.visibleFraction > 0 && mounted) {
                              _lastVisibleAyah = verse.number;
                            }
                          },
                          child: AutoScrollTag(
                            key: ValueKey(index),
                            controller: _scrollController,
                            index: index,
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _highlightedAyah = isHighlighted
                                      ? null
                                      : verse.number;
                                });
                              },
                              child: AnimatedContainer(
                                duration: AppConstants.animFast,
                                color: isHighlighted
                                    ? (isDark
                                        ? AppColors.primaryDark.withValues(alpha: 0.15)
                                        : AppColors.primary.withValues(alpha: 0.05))
                                    : Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 24),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          // ── Header Row (Badge & Actions) ──
                                          Row(
                                            children: [
                                              // Ornamental Badge
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: isDark ? theme.cardTheme.color : Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: AppColors.primary.withValues(alpha: 0.15),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                    color: AppColors.primary.withValues(alpha: 0.3),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${verse.number}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              // Actions
                                              _AyahIconButton(
                                                icon: Icons.play_arrow_rounded,
                                                color: AppColors.primary,
                                                onTap: () {
                                                  ref.read(audioPlayerProvider.notifier)
                                                    .playAyat(widget.surahNumber, verse.number, totalAyats: detail.verses.length);
                                                },
                                              ),
                                              const SizedBox(width: 4),
                                              _AyahIconButton(
                                                icon: Icons.copy_rounded,
                                                onTap: () => _copyAyah(
                                                  verse.text,
                                                  verse.translationEn,
                                                  verse.number,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              _AyahIconButton(
                                                icon: Icons.share_rounded,
                                                onTap: () => _shareAyah(
                                                  verse.text,
                                                  verse.translationEn,
                                                  verse.number,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              _AyahIconButton(
                                                icon: isBookmarked
                                                    ? Icons.bookmark_rounded
                                                    : Icons.bookmark_outline_rounded,
                                                color: isBookmarked
                                                    ? AppColors.accent
                                                    : null,
                                                onTap: () {
                                                  if (isBookmarked) {
                                                    ref
                                                        .read(bookmarksProvider.notifier)
                                                        .remove(bookmarkId);
                                                  } else {
                                                    ref
                                                        .read(bookmarksProvider.notifier)
                                                        .add(bookmarkId);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),

                                          // ── Arabic Text ──
                                          if (isWordByWordEnabled)
                                            wordTranslationsAsync.when(
                                              data: (wordsList) {
                                                try {
                                                  final verseWords = wordsList.firstWhere(
                                                    (w) => w.verseNumber == verse.number,
                                                  );
                                                  return _buildWordByWordVerse(verseWords, theme);
                                                } catch (e) {
                                                  return const Center(child: CircularProgressIndicator());
                                                }
                                              },
                                              loading: () => const Center(child: CircularProgressIndicator()),
                                              error: (e, s) => Center(child: Text('Gagal memuat kata', style: TextStyle(color: AppColors.error))),
                                            )
                                          else
                                            RichText(
                                              textAlign: TextAlign.right,
                                              text: _buildVerseText(
                                                settings.rasmType == RasmType.indoPak && verse.textIndopak != null 
                                                    ? verse.textIndopak! 
                                                    : verse.text,
                                                verse.number,
                                                detail.number,
                                                isTajwidMode,
                                              ),
                                            ),
                                          const SizedBox(height: 16),

                                          // ── Transliteration (Placeholder if enabled) ──
                                          if (settings.showTransliteration && verse.transliteration != null) ...[
                                            Text(
                                              verse.transliteration!,
                                              textAlign: TextAlign.left,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: AppColors.accent,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                          ],

                                          // ── Translation ──
                                          Text(
                                            settings.translationType == TranslationType.kemenAg
                                                ? verse.translationEn
                                                : (verse.tafsirJalalain ?? verse.translationEn),
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: theme.textTheme.bodyMedium?.color,
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Separator
                                    if (index < visibleVerses.length - 1)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Divider(
                                          height: 1,
                                          color: theme.colorScheme.outline.withValues(alpha: 0.2),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: visibleVerses.length,
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator())),
                  error: (e, s) => SliverToBoxAdapter(
                      child: Center(child: Text('Error: $e'))),
                ),
                // Add padding at the bottom from audio bar
                const SliverToBoxAdapter(
                  child: SizedBox(height: 120), 
                ),
              ],
            ),
            
            // Audio Control Bar at bottom
            const Align(
              alignment: Alignment.bottomCenter,
              child: AudioControlBar(),
            ),
          ],
        );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off_rounded,
                      size: 56, color: AppColors.error.withValues(alpha: 0.7)),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal Memuat Surah',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pastikan Anda terhubung ke internet untuk memuat surah ini.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(surahDetailProvider(widget.surahNumber));
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Coba Lagi'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AyahIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _AyahIconButton({
    required this.icon,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          icon,
          size: 20,
          color: color ?? theme.textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}
