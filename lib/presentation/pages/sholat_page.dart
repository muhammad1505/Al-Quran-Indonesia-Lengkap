import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/features/sholat/domain/entities/prayer_times.dart';
import 'package:quran_app/features/sholat/presentation/widgets/prayer_time_row.dart';
import 'package:quran_app/features/sholat/providers/prayer_times_providers.dart';

class SholatPage extends ConsumerWidget {
  const SholatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesAsync = ref.watch(prayerTimesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
      ),
      body: prayerTimesAsync.when(
        data: (prayerTimes) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context, prayerTimes),
                const SizedBox(height: 24),
                _buildTimingsCard(context, prayerTimes),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Failed to load prayer times: $error')),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PrayerTimes prayerTimes) {
    return Column(
      children: [
        Text(
          'Riyadh, Saudi Arabia', // Mock Location
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${prayerTimes.date.readable} / ${prayerTimes.date.hijriMonth} ${prayerTimes.date.hijriYear} AH',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTimingsCard(BuildContext context, PrayerTimes prayerTimes) {
    final timings = prayerTimes.timings;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          PrayerTimeRow(name: 'Fajr', time: timings.fajr, icon: Icons.brightness_4_outlined),
          const Divider(height: 1),
          PrayerTimeRow(name: 'Sunrise', time: timings.sunrise, icon: Icons.wb_sunny_outlined),
          const Divider(height: 1),
          PrayerTimeRow(name: 'Dhuhr', time: timings.dhuhr, icon: Icons.wb_sunny),
          const Divider(height: 1),
          PrayerTimeRow(name: 'Asr', time: timings.asr, icon: Icons.wb_cloudy_outlined),
          const Divider(height: 1),
          PrayerTimeRow(name: 'Maghrib', time: timings.maghrib, icon: Icons.brightness_6_outlined),
          const Divider(height: 1),
          PrayerTimeRow(name: 'Isha', time: timings.isha, icon: Icons.nights_stay_outlined),
        ],
      ),
    );
  }
}
