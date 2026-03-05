import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/features/asmaul_husna/presentation/pages/asmaul_husna_page.dart';
import 'package:quran_app/features/doa/presentation/pages/doa_harian_page.dart';
import 'package:quran_app/features/doa/presentation/pages/doa_lengkap_page.dart';
import 'package:quran_app/features/doa/presentation/pages/dzikir_page.dart';
import 'package:quran_app/features/hafalan/presentation/pages/hafalan_page.dart';
import 'package:quran_app/features/hadith/presentation/pages/hadith_page.dart';
import 'package:quran_app/features/hadith/data/models/hadith_data.dart';
import 'package:quran_app/features/hijriyah/presentation/pages/hijriyah_page.dart';
import 'package:quran_app/features/niat_sholat/presentation/pages/niat_sholat_page.dart';
import 'package:quran_app/features/qibla/presentation/pages/qibla_page.dart';
import 'package:quran_app/features/quran/presentation/pages/bookmarks_page.dart';
import 'package:quran_app/features/quran/presentation/pages/surah_page_view.dart';
import 'package:quran_app/features/quran/presentation/pages/surat_pilihan_page.dart';
import 'package:quran_app/features/tasbih/presentation/pages/tasbih_page.dart';
import 'package:quran_app/core/widgets/ui_utils.dart';
import 'package:quran_app/providers/app_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showAllFeatures = false;

  @override
  Widget build(BuildContext context) {
    final lastReadAsync = ref.watch(lastReadProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final allFeatures = [
      _FeatureTile(
        icon: Icons.bookmark_rounded,
        label: 'Bookmark',
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const BookmarksPage())),
      ),
      _FeatureTile(
        icon: Icons.star_rounded,
        label: 'Surat Pilihan',
        gradient: const LinearGradient(
          colors: [Color(0xFFF43F5E), Color(0xFFFDA4AF)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const SuratPilihanPage())),
      ),
      _FeatureTile(
        icon: Icons.menu_book_rounded,
        label: 'Hafalan',
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const HafalanPage())),
      ),
      _FeatureTile(
        icon: Icons.shield_moon_rounded,
        label: 'Doa Harian',
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const DoaHarianPage())),
      ),
      _FeatureTile(
        icon: Icons.wb_twilight_rounded,
        label: 'Dzikir',
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const DzikirPage())),
      ),
      _FeatureTile(
        icon: Icons.touch_app_rounded,
        label: 'Tasbih',
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF34D399)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const TasbihPage())),
      ),
      _FeatureTile(
        icon: Icons.explore_rounded,
        label: 'Kiblat',
        gradient: const LinearGradient(
          colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const QiblaPage())),
      ),
      _FeatureTile(
        icon: Icons.calendar_month_rounded,
        label: 'Hijriyah',
        gradient: const LinearGradient(
          colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const HijriyahPage())),
      ),
      _FeatureTile(
        icon: Icons.star_rounded,
        label: 'Asmaul Husna',
        gradient: const LinearGradient(
          colors: [Color(0xFFE11D48), Color(0xFFFB7185)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const AsmaulHusnaPage())),
      ),
      _FeatureTile(
        icon: Icons.menu_book_rounded,
        label: 'Hadits',
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const HadithPage())),
      ),
      _FeatureTile(
        icon: Icons.mosque_rounded,
        label: 'Niat Sholat',
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFFC084FC)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const NiatSholatPage())),
      ),
      _FeatureTile(
        icon: Icons.menu_book_rounded,
        label: 'Doa Lengkap',
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF6EE7B7)],
        ),
        onTap: () => Navigator.push(context,
            SlidePageRoute(page: const DoaLengkapPage())),
      ),
    ];

    final displayFeatures = _showAllFeatures 
        ? List<Widget>.from(allFeatures) 
        : allFeatures.take(5).toList();

    displayFeatures.add(
      _FeatureTile(
        icon: _showAllFeatures ? Icons.keyboard_arrow_up_rounded : Icons.grid_view_rounded,
        label: _showAllFeatures ? 'Lebih Sedikit' : 'Lainnya',
        gradient: const LinearGradient(
          colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
        ),
        onTap: () {
          setState(() {
            _showAllFeatures = !_showAllFeatures;
          });
        },
      ),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Islamic Header ──
          SliverToBoxAdapter(
            child: _IslamicHeader(isDark: isDark),
          ),

          // ── Last Read Card ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: lastReadAsync.when(
                data: (data) {
                  if (data == null) {
                    return _LastReadPlaceholder(isDark: isDark);
                  }
                  return _LastReadCardWidget(
                    surahName: data['surahName'] as String,
                    ayahNumber: data['ayahNumber'] as int,
                    surahNumber: data['surahNumber'] as int,
                    isDark: isDark,
                  );
                },
                loading: () => _LastReadPlaceholder(isDark: isDark),
                error: (_, stack) => const SizedBox.shrink(),
              ),
            ),
          ),

          // ── Feature Grid Title ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Fitur Unggulan',
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),

          // ── Feature Grid ──
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildListDelegate(displayFeatures),
            ),
          ),

          // ── Ayat Harian ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Text(
                'Ayat Hari Ini',
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _AyatHarianWidget(isDark: isDark),
            ),
          ),

          // ── Hadits Harian ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Hadits Harian',
                style: theme.textTheme.headlineSmall,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _HaditsHarianWidget(isDark: isDark, theme: theme),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}

// ── Islamic Gradient Header ──
class _IslamicHeader extends StatelessWidget {
  final bool isDark;

  const _IslamicHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.of(context).padding.top + 12, 16, 20),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeaderGradient : AppColors.headerGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assalamu\'alaikum 👋',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Al-Qur\'an Digital',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.notifications_none_rounded,
                    color: Colors.white, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.white70, size: 18),
                const SizedBox(width: 10),
                Text(
                  _getFormattedDate(),
                  style: GoogleFonts.poppins(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

// ── Last Read Card ──
class _LastReadCardWidget extends StatelessWidget {
  final String surahName;
  final int ayahNumber;
  final int surahNumber;
  final bool isDark;

  const _LastReadCardWidget({
    required this.surahName,
    required this.ayahNumber,
    required this.surahNumber,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Material(
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        elevation: 4,
        shadowColor: AppColors.primary.withValues(alpha: 0.3),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
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
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.menu_book_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terakhir Dibaca',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$surahName • Ayat $ayahNumber',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Placeholder when no last read ──
class _LastReadPlaceholder extends StatelessWidget {
  final bool isDark;

  const _LastReadPlaceholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.menu_book_rounded,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Mulai membaca Al-Qur\'an sekarang',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Feature Grid Tile ──
class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _FeatureTile({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Bounceable(
      onTap: onTap,
      child: Material(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusLG),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ayat Harian Widget ──
class _AyatHarianWidget extends StatefulWidget {
  final bool isDark;
  const _AyatHarianWidget({required this.isDark});

  @override
  State<_AyatHarianWidget> createState() => _AyatHarianWidgetState();
}

class _AyatHarianWidgetState extends State<_AyatHarianWidget> {
  Map<String, dynamic>? _ayat;
  String _surahName = '';

  // Short surahs from Juz 30 (surah 78-114) that are likely to have local data
  static const _shortSurahs = [1, 112, 113, 114];

  @override
  void initState() {
    super.initState();
    _loadRandomAyat();
  }

  Future<void> _loadRandomAyat() async {
    try {
      // Use day of year as seed for "daily" random
      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
      final surahIndex = dayOfYear % _shortSurahs.length;
      final surahNum = _shortSurahs[surahIndex];

      final jsonStr = await rootBundle
          .loadString('assets/data/surahs/$surahNum.json');
      if (!jsonStr.trim().startsWith('{')) return;

      final surahData = json.decode(jsonStr);
      final verses = surahData['verses'] as List;
      if (verses.isEmpty) return;

      final verseIndex = dayOfYear % verses.length;
      setState(() {
        _ayat = Map<String, dynamic>.from(verses[verseIndex]);
        _surahName =
            '${surahData['transliteration_en']} : ${verses[verseIndex]['number']}';
      });
    } catch (_) {
      // Silently fail — widget just won't show
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ayat == null) return const SizedBox.shrink();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: widget.isDark
            ? AppColors.darkHeaderGradient
            : const LinearGradient(
                colors: [Color(0xFFF5F3FF), Color(0xFFEDE9FE)],
              ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        border: Border.all(
          color: widget.isDark
              ? AppColors.darkCardBorder
              : const Color(0xFFDDD6FE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arabic text
          Text(
            _ayat!['text'] ?? '',
            textAlign: TextAlign.right,
            style: GoogleFonts.amiri(
              fontSize: 22,
              height: 1.8,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          // Surah reference
          Text(
            _surahName,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          // Translation
          Text(
            _ayat!['translation_en'] ?? '',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _HaditsHarianWidget extends StatelessWidget {
  final bool isDark;
  final ThemeData theme;

  const _HaditsHarianWidget({required this.isDark, required this.theme});

  @override
  Widget build(BuildContext context) {
    // Select daily hadith based on current day of the year
    final now = DateTime.now();
    final dayOfYear = int.parse(
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}");
    final dailyHadithIndex = dayOfYear % selectedHadiths.length;
    final dailyHadith = selectedHadiths[dailyHadithIndex];

    return Bounceable(
      onTap: () => Navigator.push(
          context, SlidePageRoute(page: const HadithPage())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          border: Border.all(
            color: isDark
                ? AppColors.darkCardBorder
                : AppColors.primary.withValues(alpha: 0.2),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Hadits ${dailyHadith.number}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              dailyHadith.translation,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'HR. ${dailyHadith.narrator}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      'Selengkapnya',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

