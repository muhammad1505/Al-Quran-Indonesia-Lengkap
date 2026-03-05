import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';

class TajwidPage extends StatelessWidget {
  const TajwidPage({super.key});

  void _showTajwidRule(BuildContext context, String title, String explanation) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                explanation,
                style: GoogleFonts.poppins(fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 20),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Belajar Tajwid',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Text(
                'Klik contoh untuk penjelasan',
                style: GoogleFonts.poppins(
                    color: theme.textTheme.bodySmall?.color, fontSize: 13),
              ),
            ),
          ),

          // ── Nun Sukun / Tanwin Rules ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Hukum Nun Sukun / Tanwin',
                  style: theme.textTheme.headlineSmall),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Izhar Halqi',
              subtitle: 'Dibaca jelas (tanpa dengung)',
              color: AppColors.tajwidIzhar,
              example: 'مَنْ أَعْطَى',
              source: 'Al-Lail: 5',
              onTap: () => _showTajwidRule(context, 'Izhar Halqi (إظهار حلقي)',
                  'Izhar artinya menjelaskan. Hukum ini terjadi ketika Nun sukun (نْ) atau Tanwin bertemu dengan salah satu huruf halaq: ء ه ع ح غ خ.\n\nDibaca jelas tanpa dengung.'),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Idgham Bighunnah',
              subtitle: 'Dimasukkan dengan dengung',
              color: AppColors.tajwidIdghamBighunnah,
              example: 'مَنْ يَعْمَلْ',
              source: 'An-Nisa: 123',
              onTap: () => _showTajwidRule(context, 'Idgham Bighunnah (إدغام بغنة)',
                  'Idgham artinya memasukkan. Bighunnah artinya dengan dengung. Terjadi ketika Nun sukun atau Tanwin bertemu huruf: ي ن م و (disingkat "YANMU").\n\nDibaca dengan memasukkan suara nun ke huruf setelahnya disertai dengung.'),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Idgham Bilaghunnah',
              subtitle: 'Dimasukkan tanpa dengung',
              color: AppColors.tajwidIdghamBilaaghunnah,
              example: 'مِنْ لَدُنْهُ',
              source: 'An-Nisa: 40',
              onTap: () => _showTajwidRule(context, 'Idgham Bilaghunnah (إدغام بلا غنة)',
                  'Terjadi ketika Nun sukun atau Tanwin bertemu huruf Lam (ل) atau Ra (ر).\n\nDibaca dengan memasukkan suara nun tanpa dengung.'),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Ikhfa\' Haqiqi',
              subtitle: 'Dibaca samar dengan dengung',
              color: AppColors.tajwidIkhfa,
              example: 'مِنْ شَرِّ',
              source: 'Al-Falaq: 2',
              onTap: () => _showTajwidRule(context, 'Ikhfa\' Haqiqi (إخفاء حقيقي)',
                  'Ikhfa artinya menyembunyikan/menyamarkan. Terjadi ketika Nun sukun atau Tanwin bertemu salah satu dari 15 huruf ikhfa.\n\nDibaca samar antara izhar dan idgham dengan dengung 2 harakat.'),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Iqlab',
              subtitle: 'Nun berubah menjadi Mim',
              color: AppColors.tajwidIqlab,
              example: 'مِنْ بَعْدِ',
              source: 'Al-Baqarah: 27',
              onTap: () => _showTajwidRule(context, 'Iqlab (إقلاب)',
                  'Iqlab artinya membalik/mengubah. Terjadi ketika Nun sukun atau Tanwin bertemu huruf Ba (ب).\n\nNun sukun/tanwin berubah pengucapannya menjadi bunyi Mim (م) dengan dengung.'),
            ),
          ),

          // ── Mim Sukun Rules ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Hukum Mim Sukun',
                  style: theme.textTheme.headlineSmall),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Ikhfa\' Syafawi',
              subtitle: 'Mim sukun bertemu Ba',
              color: AppColors.tajwidIkhfaSyafawi,
              example: 'تَرْمِيهِمْ بِحِجَارَةٍ',
              source: 'Al-Fil: 4',
              onTap: () => _showTajwidRule(context, 'Ikhfa\' Syafawi (إخفاء شفوي)',
                  'Terjadi ketika Mim sukun (مْ) bertemu huruf Ba (ب).\n\nDibaca samar/ditahan pada bibir dengan dengung.'),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Idgham Mimi',
              subtitle: 'Mim sukun bertemu Mim',
              color: AppColors.tajwidIdghamMimi,
              example: 'لَهُمْ مَا يَشَاءُونَ',
              source: 'An-Nahl: 31',
              onTap: () => _showTajwidRule(context, 'Idgham Mimi (إدغام ميمي)',
                  'Terjadi ketika Mim sukun (مْ) bertemu huruf Mim (م).\n\nDua mim dilebur menjadi satu dengan dengung.'),
            ),
          ),

          // ── Other Rules ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Hukum Lainnya',
                  style: theme.textTheme.headlineSmall),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Ghunnah',
              subtitle: 'Dengung pada Nun/Mim tasydid',
              color: AppColors.tajwidGhunnah,
              example: 'إِنَّ',
              source: 'Al-Fatihah: 6',
              onTap: () => _showTajwidRule(context, 'Ghunnah (غنة)',
                  'Ghunnah adalah suara dengung yang keluar dari rongga hidung.\n\nTerjadi pada Nun (نّ) atau Mim (مّ) yang bertasydid. Dengung ditahan selama 2 harakat.'),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Qalqalah',
              subtitle: 'Memantulkan huruf',
              color: AppColors.tajwidQalqalah,
              example: 'قُلْ هُوَ ٱللَّهُ أَحَدٌ',
              source: 'Al-Ikhlas: 1',
              onTap: () => _showTajwidRule(context, 'Qalqalah (قلقلة)',
                  'Qalqalah artinya memantulkan suara. Huruf qalqalah ada 5: ق ط ب ج د (disingkat "qutbu jadin").\n\nTerjadi ketika huruf tersebut dalam keadaan sukun (mati), baik di tengah maupun di akhir kata (waqaf).'),
            ),
          ),

          SliverToBoxAdapter(
            child: _TajwidRuleCard(
              title: 'Mad Thabi\'i',
              subtitle: 'Mad asli (2 harakat)',
              color: AppColors.tajwidMad,
              example: 'بِسْمِ اللَّهِ',
              source: 'Al-Fatihah: 1',
              onTap: () => _showTajwidRule(context, 'Mad Thabi\'i (مد طبيعي)',
                  'Mad Thabi\'i adalah mad dasar yang panjangnya 2 harakat.\n\nTerjadi ketika ada:\n• Alif setelah fathah\n• Waw sukun setelah dhammah\n• Ya sukun setelah kasrah\n\nTidak ada penyebab tambahan (hamzah atau sukun setelahnya).'),
            ),
          ),

          // ── Legend ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Legenda Warna', style: theme.textTheme.headlineSmall),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    children: [
                      _LegendItem(AppColors.tajwidIzhar, 'Izhar'),
                      _LegendItem(AppColors.tajwidIdghamBighunnah, 'Idgham'),
                      _LegendItem(AppColors.tajwidIkhfa, 'Ikhfa\''),
                      _LegendItem(AppColors.tajwidIqlab, 'Iqlab'),
                      _LegendItem(AppColors.tajwidGhunnah, 'Ghunnah'),
                      _LegendItem(AppColors.tajwidQalqalah, 'Qalqalah'),
                      _LegendItem(AppColors.tajwidMad, 'Mad'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tajwid Rule Card ──
class _TajwidRuleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String example;
  final String source;
  final VoidCallback onTap;

  const _TajwidRuleCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.example,
    required this.source,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            example,
                            style: GoogleFonts.amiri(
                              fontSize: 18,
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '($source)',
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: theme.textTheme.bodySmall?.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Legend Item ──
class _LegendItem extends StatelessWidget {
  final Color color;
  final String name;

  const _LegendItem(this.color, this.name);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(name, style: GoogleFonts.poppins(fontSize: 13)),
      ],
    );
  }
}
