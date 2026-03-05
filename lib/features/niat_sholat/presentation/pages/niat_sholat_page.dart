import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';

class NiatSholatPage extends StatefulWidget {
  const NiatSholatPage({super.key});

  @override
  State<NiatSholatPage> createState() => _NiatSholatPageState();
}

class _NiatSholatPageState extends State<NiatSholatPage> {
  List<dynamic> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonStr =
        await rootBundle.loadString('assets/data/niat_sholat.json');
    setState(() {
      _categories = json.decode(jsonStr);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Niat Sholat',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _categories.length,
              itemBuilder: (context, catIndex) {
                final category = _categories[catIndex];
                final items = category['data'] as List;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category header
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, catIndex == 0 ? 0 : 16, 4, 8),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            category['kategori'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Items
                    ...items.map((item) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  item['nama'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Arabic
                                Text(
                                  item['arab'],
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.amiri(
                                    fontSize: 22,
                                    height: 2.0,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Divider(
                                    color: theme.colorScheme.outline
                                        .withValues(alpha: 0.3)),
                                const SizedBox(height: 4),
                                // Latin
                                Text(
                                  item['latin'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                    color: theme.textTheme.bodyMedium?.color,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                // Terjemahan
                                Text(
                                  item['arti'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: theme.textTheme.bodySmall?.color,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                );
              },
            ),
    );
  }
}
