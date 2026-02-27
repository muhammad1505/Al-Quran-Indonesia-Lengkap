import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/domain/entities/surah_detail.dart';

class SurahDetailHeader extends StatelessWidget {
  final SurahDetail surahDetail;

  const SurahDetailHeader({super.key, required this.surahDetail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            surahDetail.transliterationEn,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            surahDetail.translationEn,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1.0,
            height: 32.0,
            indent: 40.0,
            endIndent: 40.0,
          ),
          Text(
            '${surahDetail.revelationType.toUpperCase()} - ${surahDetail.totalVerses} VERSES',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            surahDetail.name,
            style: GoogleFonts.amiri(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
