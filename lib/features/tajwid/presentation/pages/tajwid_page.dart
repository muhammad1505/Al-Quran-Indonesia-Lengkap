import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TajwidPage extends StatelessWidget {
  const TajwidPage({super.key});

  void _showTajwidRule(BuildContext context, String title, String explanation) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                explanation,
                style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 24),
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

  TapGestureRecognizer _createTapRecognizer(BuildContext context, String title, String explanation) {
    return TapGestureRecognizer()
      ..onTap = () {
        _showTajwidRule(context, title, explanation);
      };
  }

  @override
  Widget build(BuildContext context) {
    // Define colors for different rules
    final qalqalahColor = Colors.blue.shade700;
    final ghunnahColor = Colors.green.shade700;
    final ikhfaColor = Colors.orange.shade800;
    final defaultColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    // Create recognizers for each rule
    final qalqalahRecognizer = _createTapRecognizer(
      context,
      'Hukum Qalqalah (قَلْقَلَة)',
      'Qalqalah berarti memantulkan suara dari huruf-huruf tertentu yang sukun (mati), yaitu ق, ط, ب, ج, د (di singkat qutbu jadin).\n\nPada contoh ini, huruf Dal (د) di akhir ayat dibaca memantul karena waqaf (berhenti).',
    );
    final ghunnahRecognizer = _createTapRecognizer(
      context,
      'Hukum Ghunnah (غُنَّة)',
      'Ghunnah berarti membaca dengan mendengung. Ini berlaku pada huruf Nun (ن) dan Mim (م) yang bertasydid (ّ).\n\nPada contoh ini, huruf Nun (نّ) dibaca dengan dengung yang ditahan.',
    );
    final ikhfaRecognizer = _createTapRecognizer(
      context,
      'Hukum Ikhfa\' (إخفاء)',
      'Ikhfa\' berarti menyamarkan atau menyembunyikan. Ini terjadi ketika Nun sukun (نْ) atau tanwin bertemu dengan salah satu dari 15 huruf ikhfa\'. Suara Nun sukun dibaca samar-samar menuju makhraj huruf setelahnya.\n\nPada contoh ini, Nun sukun bertemu dengan Syin (ش), sehingga dibaca samar.',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Tajwid'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contoh Interaktif',
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Klik pada bagian yang berwarna untuk melihat penjelasan hukum tajwidnya.',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            // Qalqalah Example
            _TajwidExampleCard(
              title: 'Qalqalah - QS Al-Ikhlas: 1',
              textSpan: TextSpan(
                style: GoogleFonts.amiri(fontSize: 32, color: defaultColor, height: 2.0),
                children: [
                  const TextSpan(text: 'قُلْ هُوَ ٱللَّهُ أَحَ'),
                  TextSpan(
                    text: 'دٌ',
                    style: TextStyle(color: qalqalahColor, fontWeight: FontWeight.bold),
                    recognizer: qalqalahRecognizer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Ghunnah Example
            _TajwidExampleCard(
              title: 'Ghunnah - QS An-Nas: 6',
              textSpan: TextSpan(
                style: GoogleFonts.amiri(fontSize: 32, color: defaultColor, height: 2.0),
                children: [
                  const TextSpan(text: 'مِنَ ٱلْجِ'),
                  TextSpan(
                    text: 'نَّةِ',
                    style: TextStyle(color: ghunnahColor, fontWeight: FontWeight.bold),
                    recognizer: ghunnahRecognizer,
                  ),
                  const TextSpan(text: ' وَٱل'),
                  TextSpan(
                    text: 'نَّاسِ',
                    style: TextStyle(color: ghunnahColor, fontWeight: FontWeight.bold),
                    recognizer: ghunnahRecognizer,
                  ),
                ],
              ),
            ),
             const SizedBox(height: 16),
            // Ikhfa' Example
            _TajwidExampleCard(
              title: 'Ikhfa\' - QS Al-Falaq: 2',
              textSpan: TextSpan(
                style: GoogleFonts.amiri(fontSize: 32, color: defaultColor, height: 2.0),
                children: [
                  const TextSpan(text: 'مِ'),
                  TextSpan(
                    text: 'ن شَ',
                    style: TextStyle(color: ikhfaColor, fontWeight: FontWeight.bold),
                    recognizer: ikhfaRecognizer,
                  ),
                  const TextSpan(text: 'رِّ مَا خَلَقَ'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Legend
            _buildLegend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Legenda', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _LegendRow(color: Colors.blue.shade700, name: 'Qalqalah'),
            const SizedBox(height: 8),
            _LegendRow(color: Colors.green.shade700, name: 'Ghunnah'),
            const SizedBox(height: 8),
            _LegendRow(color: Colors.orange.shade800, name: 'Ikhfa\''),
          ],
        ),
      ),
    );
  }
}

class _TajwidExampleCard extends StatelessWidget {
  final String title;
  final TextSpan textSpan;

  const _TajwidExampleCard({required this.title, required this.textSpan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: RichText(
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                text: textSpan,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String name;

  const _LegendRow({required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 20, height: 20, color: color),
        const SizedBox(width: 10),
        Text(name, style: GoogleFonts.poppins(fontSize: 16)),
      ],
    );
  }
}
