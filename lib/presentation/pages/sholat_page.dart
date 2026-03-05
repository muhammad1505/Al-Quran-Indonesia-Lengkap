import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/core/providers/settings_provider.dart';
import 'package:quran_app/features/sholat/providers/sholat_providers.dart';
import 'package:quran_app/features/sholat/data/models/prayer_schedule.dart';
import 'package:quran_app/features/sholat/presentation/pages/kalender_sholat_page.dart';
import 'package:quran_app/features/sholat/presentation/pages/sholat_settings_page.dart';
import 'package:quran_app/core/widgets/ui_utils.dart';

class SholatPage extends ConsumerStatefulWidget {
  const SholatPage({super.key});

  @override
  ConsumerState<SholatPage> createState() => _SholatPageState();
}

class _SholatPageState extends ConsumerState<SholatPage> {
  bool _loading = true;
  String? _errorMessage;
  String? _cityName;
  double? _latitude;
  double? _longitude;
  PrayerSchedule? _schedule;

  @override
  void initState() {
    super.initState();
    _loadPrayerTimes();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      // 1. Check location service
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() {
          _loading = false;
          _errorMessage = 'GPS tidak aktif. Silakan aktifkan lokasi.';
        });
        return;
      }

      // 2. Check permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _loading = false;
          _errorMessage = 'Izin lokasi diperlukan untuk jadwal sholat.';
        });
        return;
      }

      // 3. Get position (fast)
      Position? position = await Geolocator.getLastKnownPosition();
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 8));

      _latitude = position.latitude;
      _longitude = position.longitude;

      // 4. Try to get city name (non-blocking)
      try {
        final placemarks = await placemarkFromCoordinates(
                position.latitude, position.longitude)
            .timeout(const Duration(seconds: 5));
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          _cityName = place.subAdministrativeArea ??
              place.locality ??
              place.administrativeArea ??
              'Lokasi Saya';
        }
      } catch (_) {
        _cityName =
            'Lat ${position.latitude.toStringAsFixed(2)}, Lon ${position.longitude.toStringAsFixed(2)}';
      }

      // 5. Read settings
      final settings = ref.read(settingsProvider);

      // 6. Fetch prayer times from Aladhan API
      final repo = ref.read(sholatRepositoryProvider);
      final schedule = await repo.getPrayerScheduleByCoords(
        latitude: position.latitude,
        longitude: position.longitude,
        date: DateTime.now(),
        locationName: _cityName ?? 'Lokasi Saya',
        method: settings.prayerCalcMethod.apiValue,
        school: settings.asrSchool.apiValue,
        latitudeAdjustmentMethod: settings.latitudeAdjustment.apiValue,
        tune: settings.tuneString,
        hijriAdjustment: settings.hijriAdjustment,
      );

      setState(() {
        _schedule = schedule;
        _loading = false;
      });

      // 7. Schedule Notifications
      _scheduleNotifications(schedule);
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage =
            'Gagal memuat jadwal sholat.\nPastikan terhubung ke internet.';
      });
    }
  }

  void _scheduleNotifications(PrayerSchedule schedule) {
    final notifService = NotificationService();
    notifService.cancelAllNotifications();

    final settings = ref.read(settingsProvider);

    final times = {
      'Subuh': schedule.jadwal.subuh,
      'Dzuhur': schedule.jadwal.dzuhur,
      'Ashar': schedule.jadwal.ashar,
      'Maghrib': schedule.jadwal.maghrib,
      'Isya': schedule.jadwal.isya,
    };

    final now = DateTime.now();
    int idCounter = 0;

    times.forEach((name, timeStr) {
      // Check if notification is enabled for this prayer
      if (!(settings.prayerNotifications[name] ?? true)) return;

      try {
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final hour = int.parse(parts[0]);
          final minute = int.parse(parts[1]);
          var scheduledTime =
              DateTime(now.year, now.month, now.day, hour, minute);

          // Pre-adzan reminder
          if (settings.preAdzanMinutes > 0) {
            final preTime = scheduledTime
                .subtract(Duration(minutes: settings.preAdzanMinutes));
            if (preTime.isAfter(now)) {
              notifService.schedulePrayerNotification(
                id: idCounter++,
                title: "⏰ ${settings.preAdzanMinutes} menit sebelum $name",
                body:
                    "Bersiap untuk sholat $name di wilayah ${_cityName ?? 'Anda'}.",
                scheduledTime: preTime,
              );
            }
          }

          // Main adzan notification
          if (scheduledTime.isAfter(now)) {
            notifService.schedulePrayerNotification(
              id: idCounter++,
              title: "🕌 Waktu Sholat $name",
              body:
                  "Telah masuk waktu sholat $name untuk wilayah ${_cityName ?? 'Anda'} dan sekitarnya.",
              scheduledTime: scheduledTime,
            );
          }

          // Dzikir pagi (15 min after Subuh)
          if (name == 'Subuh' && settings.dzikirPagiReminder) {
            final dzikirTime =
                scheduledTime.add(const Duration(minutes: 15));
            if (dzikirTime.isAfter(now)) {
              notifService.schedulePrayerNotification(
                id: idCounter++,
                title: "🤲 Dzikir Pagi",
                body: "Waktunya membaca dzikir pagi setelah sholat Subuh.",
                scheduledTime: dzikirTime,
              );
            }
          }

          // Dzikir petang (15 min after Ashar)
          if (name == 'Ashar' && settings.dzikirPetangReminder) {
            final dzikirTime =
                scheduledTime.add(const Duration(minutes: 15));
            if (dzikirTime.isAfter(now)) {
              notifService.schedulePrayerNotification(
                id: idCounter++,
                title: "🤲 Dzikir Petang",
                body:
                    "Waktunya membaca dzikir petang setelah sholat Ashar.",
                scheduledTime: dzikirTime,
              );
            }
          }
        }
      } catch (_) {}
    });
  }

  /// Format time based on settings (24h or 12h)
  String _formatTime(String time24) {
    final settings = ref.read(settingsProvider);
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Jadwal Sholat',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded, size: 22),
                tooltip: 'Pengaturan',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    SlidePageRoute(page: const SholatSettingsPage()),
                  );
                  // Reload prayer times after settings change
                  _loadPrayerTimes();
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 22),
                onPressed: _loadPrayerTimes,
              ),
            ],
            bottom: _cityName != null
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(24),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: AppColors.primary, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            _cityName!,
                            style: GoogleFonts.poppins(
                                color: AppColors.primary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          ),

          // Body
          if (_loading)
            SliverPadding(
              padding: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const ShimmerListTile(),
                  childCount: 8,
                ),
              ),
            )
          else if (_errorMessage != null)
            SliverFillRemaining(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off_rounded,
                          size: 48,
                          color: AppColors.error.withValues(alpha: 0.7)),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: _loadPrayerTimes,
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_schedule != null)
            _buildPrayerList(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildPrayerList(ThemeData theme, bool isDark) {
    final schedule = _schedule!;
    final prayers = [
      _PrayerData('Imsak', _formatTime(schedule.jadwal.imsak),
          Icons.dark_mode_outlined, false),
      _PrayerData('Subuh', _formatTime(schedule.jadwal.subuh),
          Icons.wb_twilight_rounded, true),
      _PrayerData('Terbit', _formatTime(schedule.jadwal.terbit),
          Icons.wb_sunny_outlined, false),
      _PrayerData('Dhuha', _formatTime(schedule.jadwal.dhuha),
          Icons.light_mode_rounded, false),
      _PrayerData('Dzuhur', _formatTime(schedule.jadwal.dzuhur),
          Icons.wb_sunny_rounded, true),
      _PrayerData('Ashar', _formatTime(schedule.jadwal.ashar),
          Icons.sunny_snowing, true),
      _PrayerData('Maghrib', _formatTime(schedule.jadwal.maghrib),
          Icons.wb_twilight_rounded, true),
      _PrayerData('Isya', _formatTime(schedule.jadwal.isya),
          Icons.nightlight_round, true),
    ];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // Date header
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
              child: Column(
                children: [
                  Text(
                    schedule.jadwal.tanggal,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    schedule.hijriDate,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      if (_latitude == null || _longitude == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Lokasi belum tersedia')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        SlidePageRoute(
                          page: KalenderSholatPage(
                            latitude: _latitude!,
                            longitude: _longitude!,
                            cityName: _cityName ?? 'Lokasi Saya',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: const Text('Kalender 30 Hari'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          final prayer = prayers[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: Card(
              elevation: prayer.isMajor ? 1 : 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: prayer.isMajor
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : theme.colorScheme.outline
                                .withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        prayer.icon,
                        color: prayer.isMajor
                            ? AppColors.primary
                            : theme.textTheme.bodySmall?.color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        prayer.name,
                        style: prayer.isMajor
                            ? theme.textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600)
                            : theme.textTheme.bodyMedium,
                      ),
                    ),
                    Text(
                      prayer.time,
                      style: GoogleFonts.poppins(
                        fontSize: prayer.isMajor ? 16 : 14,
                        fontWeight:
                            prayer.isMajor ? FontWeight.bold : FontWeight.w500,
                        color: prayer.isMajor
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: prayers.length + 1,
      ),
    );
  }
}

class _PrayerData {
  final String name;
  final String time;
  final IconData icon;
  final bool isMajor;
  _PrayerData(this.name, this.time, this.icon, this.isMajor);
}
