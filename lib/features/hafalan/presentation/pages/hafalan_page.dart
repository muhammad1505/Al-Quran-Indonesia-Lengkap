import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/features/hafalan/domain/entities/hafalan_progress.dart';
import 'package:quran_app/features/hafalan/providers/hafalan_providers.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';

class HafalanPage extends ConsumerWidget {
  const HafalanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hafalanList = ref.watch(hafalanProvider);
    final theme = Theme.of(context);

    // Stats
    final total = hafalanList.length;
    final selesai =
        hafalanList.where((h) => h.status == HafalanStatus.selesai).length;
    final proses =
        hafalanList.where((h) => h.status == HafalanStatus.proses).length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Hafalan',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),

          // Stats Card
          if (total > 0)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusXL),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(label: 'Total', value: '$total', color: Colors.white),
                    Container(width: 1, height: 40, color: Colors.white24),
                    _StatColumn(
                        label: 'Selesai',
                        value: '$selesai',
                        color: Colors.greenAccent),
                    Container(width: 1, height: 40, color: Colors.white24),
                    _StatColumn(
                        label: 'Proses',
                        value: '$proses',
                        color: Colors.amberAccent),
                  ],
                ),
              ),
            ),

          // Empty state or list
          if (total == 0)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_rounded,
                        size: 64,
                        color: theme.colorScheme.outline.withValues(alpha: 0.4)),
                    const SizedBox(height: 16),
                    Text('Belum ada target hafalan',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.outline)),
                    const SizedBox(height: 8),
                    Text(
                        'Tekan + untuk menambah target hafalan',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = hafalanList[index];
                  return _HafalanCard(item: item);
                },
                childCount: hafalanList.length,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.read(surahListProvider);
    surahsAsync.whenData((surahs) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXL)),
        ),
        builder: (ctx) => _AddHafalanSheet(surahs: surahs),
      );
    });
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatColumn(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}

class _HafalanCard extends ConsumerWidget {
  final HafalanProgress item;
  const _HafalanCard({required this.item});

  Color _statusColor(HafalanStatus status) {
    switch (status) {
      case HafalanStatus.selesai:
        return AppColors.success;
      case HafalanStatus.proses:
        return AppColors.warning;
      case HafalanStatus.belum:
        return Colors.grey;
    }
  }

  String _statusLabel(HafalanStatus status) {
    switch (status) {
      case HafalanStatus.selesai:
        return 'Selesai ✅';
      case HafalanStatus.proses:
        return 'Sedang Dihafal';
      case HafalanStatus.belum:
        return 'Belum Mulai';
    }
  }

  IconData _statusIcon(HafalanStatus status) {
    switch (status) {
      case HafalanStatus.selesai:
        return Icons.check_circle_rounded;
      case HafalanStatus.proses:
        return Icons.autorenew_rounded;
      case HafalanStatus.belum:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = _statusColor(item.status);
    final progressPercent = item.progress / 100.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showStatusMenu(context, ref),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${item.surahNumber}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: color,
                              fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.surahName,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          Text(
                            'Ayat ${item.ayatFrom} - ${item.ayatTo} (${item.ayatTo - item.ayatFrom + 1} ayat)',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(_statusIcon(item.status), color: color, size: 24),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress bar
                ClipRoundedRect(
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    backgroundColor: color.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_statusLabel(item.status),
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: color)),
                    Text('${item.progress}%',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ],
                ),
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(item.notes!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showStatusMenu(BuildContext context, WidgetRef ref) {
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
                child: Text(item.surahName,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              const Divider(height: 1),
              ...HafalanStatus.values.map((status) {
                final isSelected = item.status == status;
                return ListTile(
                  leading: Icon(_statusIcon(status),
                      color: _statusColor(status)),
                  title: Text(_statusLabel(status)),
                  trailing: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref
                        .read(hafalanProvider.notifier)
                        .updateStatus(item.id, status);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const Divider(height: 1),
              ListTile(
                leading:
                    const Icon(Icons.delete_rounded, color: AppColors.error),
                title: const Text('Hapus',
                    style: TextStyle(color: AppColors.error)),
                onTap: () {
                  ref.read(hafalanProvider.notifier).remove(item.id);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class ClipRoundedRect extends StatelessWidget {
  final Widget child;
  const ClipRoundedRect({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: child,
    );
  }
}

// ── Add Hafalan Bottom Sheet ──
class _AddHafalanSheet extends ConsumerStatefulWidget {
  final List<dynamic> surahs;
  const _AddHafalanSheet({required this.surahs});

  @override
  ConsumerState<_AddHafalanSheet> createState() => _AddHafalanSheetState();
}

class _AddHafalanSheetState extends ConsumerState<_AddHafalanSheet> {
  int _selectedSurah = 1;
  int _ayatFrom = 1;
  int _ayatTo = 7;
  final _notesController = TextEditingController();

  dynamic get _currentSurah =>
      widget.surahs.firstWhere((s) => s.number == _selectedSurah);

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxAyat = _currentSurah.totalVerses as int;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
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
          const SizedBox(height: 16),
          Center(
            child: Text('Tambah Target Hafalan',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          const SizedBox(height: 20),

          // Surah selector
          Text('Surah',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          DropdownButtonFormField<int>(
            initialValue: _selectedSurah,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            isExpanded: true,
            items: widget.surahs.map((s) {
              return DropdownMenuItem<int>(
                value: s.number as int,
                child: Text('${s.number}. ${s.name}',
                    style: GoogleFonts.poppins(fontSize: 14)),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedSurah = val;
                  _ayatFrom = 1;
                  final max = _currentSurah.totalVerses as int;
                  _ayatTo = max;
                });
              }
            },
          ),
          const SizedBox(height: 16),

          // Ayat range
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ayat Dari',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: '$_ayatFrom',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onChanged: (val) {
                        final v = int.tryParse(val);
                        if (v != null && v >= 1 && v <= maxAyat) {
                          setState(() => _ayatFrom = v);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ayat Sampai',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: '$_ayatTo',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onChanged: (val) {
                        final v = int.tryParse(val);
                        if (v != null && v >= 1 && v <= maxAyat) {
                          setState(() => _ayatTo = v);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notes
          Text('Catatan (opsional)',
              style:
                  GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 4),
          TextFormField(
            controller: _notesController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Tambahkan catatan...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_ayatFrom > _ayatTo) return;
                final surah = _currentSurah;
                final item = HafalanProgress(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  surahNumber: surah.number as int,
                  surahName: surah.name as String,
                  totalAyat: surah.totalVerses as int,
                  ayatFrom: _ayatFrom,
                  ayatTo: _ayatTo,
                  notes: _notesController.text.isEmpty
                      ? null
                      : _notesController.text,
                );
                ref.read(hafalanProvider.notifier).add(item);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }
}
