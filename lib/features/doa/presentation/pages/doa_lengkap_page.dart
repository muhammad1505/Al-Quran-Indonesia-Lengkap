import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';

class DoaLengkapPage extends StatefulWidget {
  const DoaLengkapPage({super.key});

  @override
  State<DoaLengkapPage> createState() => _DoaLengkapPageState();
}

class _DoaLengkapPageState extends State<DoaLengkapPage> {
  List<dynamic> _categories = [];
  bool _loading = true;
  int _expandedCategory = -1;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonStr =
        await rootBundle.loadString('assets/data/doa_lengkap.json');
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
        title: Text('Doa Sehari-hari',
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
                final isExpanded = _expandedCategory == catIndex;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      // Category header (tappable)
                      InkWell(
                        onTap: () {
                          setState(() {
                            _expandedCategory = isExpanded ? -1 : catIndex;
                          });
                        },
                        borderRadius: BorderRadius.vertical(
                          top: const Radius.circular(12),
                          bottom: isExpanded
                              ? Radius.zero
                              : const Radius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _getCategoryIcon(category['kategori']),
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category['kategori'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${items.length} doa',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: const Icon(
                                    Icons.keyboard_arrow_down_rounded),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Expandable items
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Column(
                          children: [
                            Divider(
                              height: 1,
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                            ...items.map((item) => Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      14, 10, 14, 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        item['judul'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['arab'],
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.amiri(
                                          fontSize: 22,
                                          height: 1.8,
                                          color: theme
                                              .textTheme.bodyLarge?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item['arti'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: theme
                                              .textTheme.bodySmall?.color,
                                          height: 1.4,
                                        ),
                                      ),
                                      Divider(
                                        color: theme.colorScheme.outline
                                            .withValues(alpha: 0.15),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  IconData _getCategoryIcon(String kategori) {
    switch (kategori) {
      case 'Doa Makan':
        return Icons.restaurant_rounded;
      case 'Doa Tidur':
        return Icons.bedtime_rounded;
      case 'Doa Bepergian':
        return Icons.directions_car_rounded;
      case 'Doa Masjid':
        return Icons.mosque_rounded;
      case 'Doa Berpakaian':
        return Icons.checkroom_rounded;
      case 'Doa Kamar Mandi':
        return Icons.water_drop_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}
