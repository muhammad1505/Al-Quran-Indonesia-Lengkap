import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/features/audio/presentation/providers/audio_download_provider.dart';
import 'package:quran_app/features/audio/presentation/providers/audio_player_provider.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';

class AudioManagerPage extends ConsumerWidget {
  const AudioManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final surahsAsync = ref.watch(surahListProvider);
    final downloadState = ref.watch(audioDownloadProvider);
    final qoriListAsync = ref.watch(qoriListProvider);
    final selectedQori = ref.watch(audioPlayerProvider.select((s) => s.selectedQori));

    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Manager', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Qori Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2))),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: qoriListAsync.when(
                    data: (qoris) {
                      final currentQori = downloadState.currentQori ??
                          selectedQori ??
                          qoris.first;

                      return DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: currentQori.id,
                          items: qoris.map((q) {
                            return DropdownMenuItem(
                              value: q.id,
                              child: Text(
                                '${q.name} (${q.style})',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (id) {
                            if (id != null) {
                              final selected = qoris.firstWhere((q) => q.id == id);
                              ref.read(audioDownloadProvider.notifier).init(selected);
                              // Keep the player aligned
                              ref.read(audioPlayerProvider.notifier).setQori(selected);
                            }
                          },
                        ),
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (_, stack) => const Text('Failed to load Qoris'),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: surahsAsync.when(
              data: (surahs) {
                return ListView.separated(
                  itemCount: surahs.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    final isDownloaded = downloadState.downloadedSurahs.contains(surah.number);
                    final progress = downloadState.downloadingProgress[surah.number];
                    final isDownloading = progress != null;

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${surah.number}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary),
                          ),
                        ),
                      ),
                      title: Text(
                        surah.name,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${surah.totalVerses} Ayat',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                      ),
                      trailing: _buildTrailing(ref, surah.number, isDownloaded, isDownloading, progress),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailing(WidgetRef ref, int surahNumber, bool isDownloaded, bool isDownloading, double? progress) {
    if (isDownloading) {
      return SizedBox(
        width: 48,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            Text(
              '${((progress ?? 0) * 100).toInt()}%',
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    } else if (isDownloaded) {
      return IconButton(
        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
        onPressed: () {
          ref.read(audioDownloadProvider.notifier).deleteSurah(surahNumber);
        },
        tooltip: 'Hapus Audio',
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.cloud_download_outlined, color: AppColors.primary),
        onPressed: () {
          ref.read(audioDownloadProvider.notifier).downloadSurah(surahNumber);
        },
        tooltip: 'Download Audio',
      );
    }
  }
}
