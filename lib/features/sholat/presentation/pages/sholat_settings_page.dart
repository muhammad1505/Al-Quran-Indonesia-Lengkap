import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/core/providers/settings_provider.dart';
import 'package:quran_app/core/services/notification_service.dart';

class SholatSettingsPage extends ConsumerWidget {
  const SholatSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Jadwal Sholat',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Section 1: Prayer Calculation ──
          _SectionHeader(title: 'Perhitungan Jadwal Sholat'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                // Auto toggle
                SwitchListTile.adaptive(
                  secondary: _SettingIcon(
                    icon: Icons.auto_fix_high_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text('Otomatis',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(
                      'Gunakan metode Kemenag RI secara otomatis',
                      style: theme.textTheme.bodySmall),
                  value: settings.autoCalcMethod,
                  onChanged: (val) =>
                      ref.read(settingsProvider.notifier).setAutoCalcMethod(val),
                  activeTrackColor: AppColors.primary,
                ),
                const Divider(height: 0, indent: 60),

                // Calculation Method
                _DropdownTile<PrayerCalcMethod>(
                  icon: Icons.calculate_rounded,
                  iconColor: AppColors.info,
                  title: 'Metode Perhitungan',
                  subtitle: settings.prayerCalcMethod.label,
                  enabled: !settings.autoCalcMethod,
                  items: PrayerCalcMethod.values
                      .map((m) => DropdownMenuItem(
                            value: m,
                            child: Text(m.label,
                                style: const TextStyle(fontSize: 13)),
                          ))
                      .toList(),
                  value: settings.prayerCalcMethod,
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setPrayerCalcMethod(val);
                    }
                  },
                ),
                const Divider(height: 0, indent: 60),

                // Asr School
                ListTile(
                  leading: _SettingIcon(
                    icon: Icons.mosque_rounded,
                    color: AppColors.accent,
                  ),
                  title: Text('Perhitungan Waktu Ashar',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(settings.asrSchool.label,
                      style: theme.textTheme.bodySmall),
                  trailing: DropdownButton<AsrSchool>(
                    value: settings.asrSchool,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(settingsProvider.notifier).setAsrSchool(val);
                      }
                    },
                    items: AsrSchool.values
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.label,
                                  style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                  ),
                ),
                const Divider(height: 0, indent: 60),

                // Latitude Adjustment
                ListTile(
                  leading: _SettingIcon(
                    icon: Icons.public_rounded,
                    color: AppColors.success,
                  ),
                  title: Text('Penyesuaian Lintang',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(
                      'Metode: ${settings.latitudeAdjustment.label}',
                      style: theme.textTheme.bodySmall),
                  trailing: DropdownButton<LatitudeAdjustment>(
                    value: settings.latitudeAdjustment,
                    underline: const SizedBox(),
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    onChanged: (val) {
                      if (val != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setLatitudeAdjustment(val);
                      }
                    },
                    items: LatitudeAdjustment.values
                        .map((l) => DropdownMenuItem(
                              value: l,
                              child: Text(l.label,
                                  style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                  ),
                ),
                const Divider(height: 0, indent: 60),

                // Personal Adjustments
                ListTile(
                  leading: _SettingIcon(
                    icon: Icons.tune_rounded,
                    color: AppColors.warning,
                  ),
                  title: Text('Penyesuaian Personal',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(
                      'Tambah/kurangi menit dari standar',
                      style: theme.textTheme.bodySmall),
                  trailing: Icon(Icons.chevron_right_rounded,
                      color: theme.textTheme.bodySmall?.color),
                  onTap: () => _showPersonalAdjustments(context, ref, settings),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Section 2: Hijri Date ──
          _SectionHeader(title: 'Perhitungan Tanggal Hijriah'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                // Auto Hijri
                SwitchListTile.adaptive(
                  secondary: _SettingIcon(
                    icon: Icons.auto_fix_high_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text('Otomatis',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(
                      'Gunakan metode Imkanur Rukyat (Hilal 3°)',
                      style: theme.textTheme.bodySmall),
                  value: settings.autoHijriMethod,
                  onChanged: (val) =>
                      ref.read(settingsProvider.notifier).setAutoHijriMethod(val),
                  activeTrackColor: AppColors.primary,
                ),
                const Divider(height: 0, indent: 60),

                // Hijri Date Adjustment
                ListTile(
                  leading: _SettingIcon(
                    icon: Icons.date_range_rounded,
                    color: AppColors.accent,
                  ),
                  title: Text('Penyesuaian Tanggal Hijriah',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(
                      settings.hijriAdjustment == 0
                          ? 'Tanpa penyesuaian'
                          : '${settings.hijriAdjustment > 0 ? '+' : ''}${settings.hijriAdjustment} hari',
                      style: theme.textTheme.bodySmall),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text('-2'),
                      Expanded(
                        child: Slider(
                          value: settings.hijriAdjustment.toDouble(),
                          min: -2,
                          max: 2,
                          divisions: 4,
                          label: settings.hijriAdjustment.toString(),
                          activeColor: AppColors.primary,
                          onChanged: (val) => ref
                              .read(settingsProvider.notifier)
                              .setHijriAdjustment(val.toInt()),
                        ),
                      ),
                      const Text('+2'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Section 3: Notifications ──
          _SectionHeader(title: 'Notifikasi'),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                // Per-prayer toggles
                ...['Subuh', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya'].map(
                  (name) => SwitchListTile.adaptive(
                    secondary: _SettingIcon(
                      icon: Icons.notifications_active_rounded,
                      color: AppColors.primary,
                    ),
                    title: Text('Notifikasi $name',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                    value: settings.prayerNotifications[name] ?? true,
                    onChanged: (val) => ref
                        .read(settingsProvider.notifier)
                        .setPrayerNotification(name, val),
                    activeTrackColor: AppColors.primary,
                    dense: true,
                  ),
                ),
                const Divider(height: 0, indent: 60),

                // Pre-adzan
                ListTile(
                  leading: _SettingIcon(
                    icon: Icons.timer_rounded,
                    color: AppColors.warning,
                  ),
                  title: Text('Pengingat Sebelum Adzan',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text(
                      settings.preAdzanMinutes == 0
                          ? 'Mati'
                          : '${settings.preAdzanMinutes} menit sebelum',
                      style: theme.textTheme.bodySmall),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text('0'),
                      Expanded(
                        child: Slider(
                          value: settings.preAdzanMinutes.toDouble(),
                          min: 0,
                          max: 30,
                          divisions: 6,
                          label: '${settings.preAdzanMinutes} menit',
                          activeColor: AppColors.primary,
                          onChanged: (val) => ref
                              .read(settingsProvider.notifier)
                              .setPreAdzanMinutes(val.toInt()),
                        ),
                      ),
                      const Text('30'),
                    ],
                  ),
                ),
                const Divider(height: 0, indent: 60),

                // Dzikir Pagi
                SwitchListTile.adaptive(
                  secondary: _SettingIcon(
                    icon: Icons.wb_sunny_rounded,
                    color: AppColors.accent,
                  ),
                  title: Text('Pengingat Dzikir Pagi',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text('Setelah sholat Subuh',
                      style: theme.textTheme.bodySmall),
                  value: settings.dzikirPagiReminder,
                  onChanged: (val) => ref
                      .read(settingsProvider.notifier)
                      .setDzikirPagiReminder(val),
                  activeTrackColor: AppColors.primary,
                ),
                const Divider(height: 0, indent: 60),

                // Dzikir Petang
                SwitchListTile.adaptive(
                  secondary: _SettingIcon(
                    icon: Icons.nightlight_round,
                    color: AppColors.info,
                  ),
                  title: Text('Pengingat Dzikir Petang',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 15)),
                  subtitle: Text('Setelah sholat Ashar',
                      style: theme.textTheme.bodySmall),
                  value: settings.dzikirPetangReminder,
                  onChanged: (val) => ref
                      .read(settingsProvider.notifier)
                      .setDzikirPetangReminder(val),
                  activeTrackColor: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          
          // Test Notification Button
          FilledButton.tonalIcon(
            onPressed: () {
              final notifService = NotificationService();
              notifService.schedulePrayerNotification(
                id: 999, // special ID for test
                title: 'Percobaan Notifikasi',
                body: 'Ini adalah tes notifikasi. Notifikasi berfungsi dengan baik!',
                scheduledTime: DateTime.now().add(const Duration(seconds: 5)),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifikasi akan muncul dalam 5 detik...')),
              );
            },
            icon: const Icon(Icons.notifications_active_rounded),
            label: const Text('Tes Notifikasi (Mundur 5 Detik)'),
          ),

          const SizedBox(height: 24),

          // ── Section 4: Other ── 
          _SectionHeader(title: 'Pengaturan Lainnya'),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile.adaptive(
              secondary: _SettingIcon(
                icon: Icons.access_time_rounded,
                color: AppColors.info,
              ),
              title: Text('Format 24 Jam',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15)),
              subtitle: Text(
                  settings.use24HourFormat ? '14:30' : '2:30 PM',
                  style: theme.textTheme.bodySmall),
              value: settings.use24HourFormat,
              onChanged: (val) =>
                  ref.read(settingsProvider.notifier).setUse24HourFormat(val),
              activeTrackColor: AppColors.primary,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showPersonalAdjustments(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _PersonalAdjustmentSheet(settings: settings),
    );
  }
}

// ── Section Header ──
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}

// ── Setting Icon Container ──
class _SettingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _SettingIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

// ── Dropdown Tile ──
class _DropdownTile<T> extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool enabled;
  final List<DropdownMenuItem<T>> items;
  final T value;
  final void Function(T?) onChanged;

  const _DropdownTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      enabled: enabled,
      leading: _SettingIcon(icon: icon, color: iconColor),
      title: Text(title,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, fontSize: 15)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      trailing: Icon(Icons.chevron_right_rounded,
          color: theme.textTheme.bodySmall?.color),
      onTap: enabled
          ? () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusXL)),
                ),
                builder: (ctx) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(title,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const Divider(height: 1),
                        Flexible(
                          child: ListView(
                            shrinkWrap: true,
                            children: items.map((item) {
                              final isSelected =
                                  (item.value as dynamic) == value;
                              return ListTile(
                                title: item.child,
                                trailing: isSelected
                                    ? const Icon(Icons.check_circle_rounded,
                                        color: AppColors.primary)
                                    : null,
                                onTap: () {
                                  onChanged(item.value);
                                  Navigator.pop(ctx);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          : null,
    );
  }
}

// ── Personal Adjustment Bottom Sheet ──
class _PersonalAdjustmentSheet extends ConsumerStatefulWidget {
  final SettingsState settings;
  const _PersonalAdjustmentSheet({required this.settings});

  @override
  ConsumerState<_PersonalAdjustmentSheet> createState() =>
      _PersonalAdjustmentSheetState();
}

class _PersonalAdjustmentSheetState
    extends ConsumerState<_PersonalAdjustmentSheet> {
  late Map<String, int> _adjustments;

  static const _prayerNames = {
    'Imsak': 'Imsak',
    'Fajr': 'Subuh',
    'Sunrise': 'Terbit',
    'Dhuhr': 'Dzuhur',
    'Asr': 'Ashar',
    'Maghrib': 'Maghrib',
    'Isha': 'Isya',
  };

  @override
  void initState() {
    super.initState();
    _adjustments = Map.from(widget.settings.prayerTimeAdjustments);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
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
          const SizedBox(height: 16),
          Text('Penyesuaian Waktu Sholat',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text('Tambah atau kurangi menit dari waktu standar',
              style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          ..._prayerNames.entries.map((entry) {
            final key = entry.key;
            final label = entry.value;
            final value = _adjustments[key] ?? 0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(label,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline_rounded),
                    onPressed: value > -30
                        ? () => setState(() => _adjustments[key] = value - 1)
                        : null,
                    color: AppColors.error,
                    iconSize: 28,
                  ),
                  SizedBox(
                    width: 50,
                    child: Text(
                      '${value >= 0 ? '+' : ''}$value',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: value == 0
                            ? theme.textTheme.bodyLarge?.color
                            : (value > 0
                                ? AppColors.success
                                : AppColors.error),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    onPressed: value < 30
                        ? () => setState(() => _adjustments[key] = value + 1)
                        : null,
                    color: AppColors.success,
                    iconSize: 28,
                  ),
                  Text('menit',
                      style: theme.textTheme.bodySmall),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      for (final key in _adjustments.keys) {
                        _adjustments[key] = 0;
                      }
                    });
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    for (final entry in _adjustments.entries) {
                      ref
                          .read(settingsProvider.notifier)
                          .setPrayerTimeAdjustment(entry.key, entry.value);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
