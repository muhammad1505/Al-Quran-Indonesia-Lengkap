import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/providers/settings_provider.dart';

class HijriyahPage extends ConsumerStatefulWidget {
  const HijriyahPage({super.key});

  @override
  ConsumerState<HijriyahPage> createState() => _HijriyahPageState();
}

class _HijriyahPageState extends ConsumerState<HijriyahPage> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _hijri;
  Map<String, dynamic>? _gregorian;

  // Hari-hari penting Islam
  static const List<Map<String, String>> _importantDays = [
    {'tanggal': '1 Muharram', 'nama': 'Tahun Baru Hijriyah'},
    {'tanggal': '10 Muharram', 'nama': 'Hari Asyura'},
    {'tanggal': '12 Rabiul Awal', 'nama': 'Maulid Nabi Muhammad SAW'},
    {'tanggal': '27 Rajab', 'nama': 'Isra Mi\'raj'},
    {'tanggal': '15 Sya\'ban', 'nama': 'Nisfu Sya\'ban'},
    {'tanggal': '1 Ramadhan', 'nama': 'Awal Puasa Ramadhan'},
    {'tanggal': '17 Ramadhan', 'nama': 'Nuzulul Quran'},
    {'tanggal': '1 Syawal', 'nama': 'Hari Raya Idul Fitri'},
    {'tanggal': '10 Dzulhijjah', 'nama': 'Hari Raya Idul Adha'},
  ];

  @override
  void initState() {
    super.initState();
    _loadHijriDate();
  }

  Future<void> _loadHijriDate() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final settings = ref.read(settingsProvider);
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

      // Use settings for method and hijri adjustment
      final response = await http
          .get(Uri.parse(
              'https://api.aladhan.com/v1/timings/$dateStr'
              '?latitude=-6.2&longitude=106.8'
              '&method=${settings.prayerCalcMethod.apiValue}'
              '&adjustment=${settings.hijriAdjustment}'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          _hijri = data['date']['hijri'];
          _gregorian = data['date']['gregorian'];
          _loading = false;
        });
      } else {
        throw Exception(
            'Gagal memuat data dari API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error =
            'Gagal memuat kalender. Pastikan terhubung ke internet dan coba lagi.';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender Hijriyah',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off_rounded, size: 48),
                        const SizedBox(height: 12),
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _loadHijriDate,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Hijri date card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? AppColors.darkHeaderGradient
                              : AppColors.headerGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Hari Ini',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _hijri?['day'] ?? '',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${(_hijri?['month'] as Map?)?['ar'] ?? ''} ${_hijri?['year'] ?? ''}',
                              style: GoogleFonts.amiri(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${(_hijri?['month'] as Map?)?['en'] ?? ''} ${_hijri?['year'] ?? ''} H',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _gregorian?['date'] ?? '',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Important days
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hari Besar Islam',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...List.generate(_importantDays.length, (index) {
                        final day = _importantDays[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.event_rounded,
                                  color: AppColors.primary, size: 20),
                            ),
                            title: Text(
                              day['nama']!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              day['tanggal']!,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
    );
  }
}
