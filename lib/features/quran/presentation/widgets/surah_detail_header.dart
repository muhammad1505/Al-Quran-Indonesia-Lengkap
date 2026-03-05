import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/domain/entities/surah_detail.dart';

class SurahDetailHeader extends StatelessWidget {
  final SurahDetail surahDetail;

  const SurahDetailHeader({super.key, required this.surahDetail});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkHeaderGradient
            : AppColors.headerGradient,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              surahDetail.name,
              style: GoogleFonts.amiri(
                color: Colors.white,
                fontSize: 32,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            surahDetail.transliterationEn,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            surahDetail.translationEn,
            style: GoogleFonts.poppins(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusRound),
            ),
            child: Text(
              '${surahDetail.revelationType.toLowerCase() == 'meccan' ? 'MAKKIYAH' : 'MADANIYAH'} • ${surahDetail.totalVerses} AYAT',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 11,
                letterSpacing: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
