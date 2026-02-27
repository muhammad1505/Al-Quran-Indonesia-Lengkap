import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/features/doa/presentation/pages/doa_harian_page.dart';
import 'package:quran_app/features/doa/presentation/pages/dzikir_page.dart';
import 'package:quran_app/features/profile/presentation/pages/profile_page.dart';
import 'package:quran_app/features/qibla/presentation/pages/qibla_page.dart';
import 'package:quran_app/features/tasbih/presentation/pages/tasbih_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of features to display
    final features = [
      {'title': 'Profil', 'icon': Icons.person_outline, 'page': const ProfilePage()},
      {'title': 'Tasbih Digital', 'icon': Icons.fingerprint, 'page': const TasbihPage()},
      {'title': 'Doa Sehari-hari', 'icon': Icons.shield_moon_outlined, 'page': const DoaHarianPage()},
      {'title': 'Dzikir Pagi & Petang', 'icon': Icons.wb_sunny_outlined, 'page': const DzikirPage()},
      {'title': 'Kompas Kiblat', 'icon': Icons.explore_outlined, 'page': const QiblaPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lainnya'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.2,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          final feature = features[index];
          return _FeatureCard(
            title: feature['title'] as String,
            icon: feature['icon'] as IconData,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => feature['page'] as Widget),
              );
            },
          );
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
