import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/domain/entities/surah.dart';

class SurahListTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahListTile({
    super.key,
    required this.surah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Surah Number
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/islamic_star.svg',
                    width: 40,
                    height: 40,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    surah.number.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16.0),
              // Surah Name and Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.transliterationEn,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${surah.revelationType.toUpperCase()} - ${surah.totalVerses} VERSES',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              // Arabic Name
              Text(
                surah.name,
                style: GoogleFonts.amiri(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
