import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LastReadCard extends StatelessWidget {
  final String surahName;
  final int ayahNumber;
  final VoidCallback onTap;

  const LastReadCard({
    super.key,
    required this.surahName,
    required this.ayahNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: theme.colorScheme.primary,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(Icons.history, color: Colors.white.withOpacity(0.8), size: 30),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LAST READ',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '$surahName, Ayah $ayahNumber',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
