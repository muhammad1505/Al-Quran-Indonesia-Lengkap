import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/widgets/ui_utils.dart';
import 'package:quran_app/features/quran/presentation/pages/surah_detail_page.dart';

class SuratPilihanPage extends StatelessWidget {
  const SuratPilihanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final suratPilihanList = [
      {
        'title': 'Ayat Kursi',
        'subtitle': 'Al-Baqarah • Ayat 255',
        'icon': Icons.menu_book_rounded,
        'action': () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const SurahDetailPage(
                surahNumber: 2,
                surahName: 'Al-Baqarah',
                initialAyahNumber: 255,
                singleAyahMode: true,
              ),
            ),
          );
        },
      },
      {
        'title': 'Surat Yasin',
        'subtitle': 'Surat ke-36 • 83 Ayat',
        'icon': Icons.menu_book_rounded,
        'action': () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const SurahDetailPage(
                surahNumber: 36,
                surahName: 'Yaseen',
              ),
            ),
          );
        },
      },
      {
        'title': 'Surat Al-Kahf',
        'subtitle': 'Surat ke-18 • 110 Ayat',
        'icon': Icons.menu_book_rounded,
        'action': () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const SurahDetailPage(
                surahNumber: 18,
                surahName: 'Al-Kahf',
              ),
            ),
          );
        },
      },
      {
        'title': 'Surat Ar-Rahman',
        'subtitle': 'Surat ke-55 • 78 Ayat',
        'icon': Icons.menu_book_rounded,
        'action': () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const SurahDetailPage(
                surahNumber: 55,
                surahName: 'Ar-Rahman',
              ),
            ),
          );
        },
      },
      {
        'title': 'Surat Al-Waqi\'ah',
        'subtitle': 'Surat ke-56 • 96 Ayat',
        'icon': Icons.menu_book_rounded,
        'action': () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const SurahDetailPage(
                surahNumber: 56,
                surahName: 'Al-Waqi\'ah',
              ),
            ),
          );
        },
      },
      {
        'title': 'Surat Al-Mulk',
        'subtitle': 'Surat ke-67 • 30 Ayat',
        'icon': Icons.menu_book_rounded,
        'action': () {
          Navigator.push(
            context,
            SlidePageRoute(
              page: const SurahDetailPage(
                surahNumber: 67,
                surahName: 'Al-Mulk',
              ),
            ),
          );
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surat Pilihan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: suratPilihanList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = suratPilihanList[index];
          return Bounceable(
            onTap: item['action'] as VoidCallback,
            child: Container(
              decoration: BoxDecoration(
                color: theme.cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkCardBorder : Colors.grey.shade200,
                ),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                title: Text(
                  item['title'] as String,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.poppins(
                    color: theme.textTheme.bodySmall?.color,
                    fontSize: 13,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
