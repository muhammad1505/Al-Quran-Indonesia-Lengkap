import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/features/doa/domain/entities/doa.dart';

class DoaListCard extends StatelessWidget {
  final Doa doa;
  const DoaListCard({super.key, required this.doa});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              doa.title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              doa.arabic,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 24,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 8.0),
            if (doa.latin != null && doa.latin!.isNotEmpty)
              Text(
                doa.latin!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              doa.translation,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
              ),
            ),
             if (doa.notes != null && doa.notes!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Catatan: ${doa.notes}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
