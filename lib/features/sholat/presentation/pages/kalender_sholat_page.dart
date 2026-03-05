import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/core/providers/settings_provider.dart';
import 'package:quran_app/features/sholat/providers/sholat_providers.dart';

class KalenderSholatPage extends ConsumerStatefulWidget {
  final double latitude;
  final double longitude;
  final String cityName;

  const KalenderSholatPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });

  @override
  ConsumerState<KalenderSholatPage> createState() => _KalenderSholatPageState();
}

class _KalenderSholatPageState extends ConsumerState<KalenderSholatPage> {
  final DateTime now = DateTime.now();

  /// Format time based on settings (24h or 12h)
  String _formatTime(String time24, SettingsState settings) {
    if (settings.use24HourFormat) return time24;
    try {
      final parts = time24.split(':');
      if (parts.length == 2) {
        var hour = int.parse(parts[0]);
        final min = parts[1];
        final period = hour >= 12 ? 'PM' : 'AM';
        if (hour > 12) hour -= 12;
        if (hour == 0) hour = 12;
        return '$hour:$min $period';
      }
    } catch (_) {}
    return time24;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalender Sholat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final theme = Theme.of(context);
          final monthlyScheduleAsync = ref.watch(
            monthlyPrayerScheduleByCoordsProvider(
              latitude: widget.latitude,
              longitude: widget.longitude,
              month: now.month,
              year: now.year,
              locationName: widget.cityName,
              method: settings.prayerCalcMethod.apiValue,
              school: settings.asrSchool.apiValue,
              latitudeAdjustmentMethod: settings.latitudeAdjustment.apiValue,
              tune: settings.tuneString,
              hijriAdjustment: settings.hijriAdjustment,
            ),
          );

          return monthlyScheduleAsync.when(
            data: (schedules) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusLG),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => theme.colorScheme.primaryContainer),
                      headingTextStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      dataRowMinHeight: 48,
                      dataRowMaxHeight: 56,
                      columnSpacing: 24,
                      columns: const [
                        DataColumn(label: Text('Tanggal')),
                        DataColumn(label: Text('Hijriah')),
                        DataColumn(label: Text('Imsak')),
                        DataColumn(label: Text('Subuh')),
                        DataColumn(label: Text('Dzuhur')),
                        DataColumn(label: Text('Ashar')),
                        DataColumn(label: Text('Maghrib')),
                        DataColumn(label: Text('Isya')),
                      ],
                      rows: schedules.asMap().entries.map((entry) {
                        final index = entry.key;
                        final schedule = entry.value;
                        final isToday = (index + 1) == now.day;
                        final rowColor = isToday
                            ? theme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : Colors.transparent;

                        return DataRow(
                          color: WidgetStateProperty.all(rowColor),
                          cells: [
                            DataCell(Text(
                              schedule.date,
                              style: GoogleFonts.poppins(
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isToday
                                      ? theme.colorScheme.primary
                                      : null),
                            )),
                            DataCell(Text(schedule.hijriDate,
                                style: GoogleFonts.poppins())),
                            DataCell(Text(
                                _formatTime(schedule.jadwal.imsak, settings),
                                style: GoogleFonts.poppins())),
                            DataCell(Text(
                                _formatTime(schedule.jadwal.subuh, settings),
                                style: GoogleFonts.poppins())),
                            DataCell(Text(
                                _formatTime(schedule.jadwal.dzuhur, settings),
                                style: GoogleFonts.poppins())),
                            DataCell(Text(
                                _formatTime(schedule.jadwal.ashar, settings),
                                style: GoogleFonts.poppins())),
                            DataCell(Text(
                                _formatTime(schedule.jadwal.maghrib, settings),
                                style: GoogleFonts.poppins())),
                            DataCell(Text(
                                _formatTime(schedule.jadwal.isya, settings),
                                style: GoogleFonts.poppins())),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) => Center(child: Text('Error: $e')),
          );
        },
      ),
    );
  }
}
