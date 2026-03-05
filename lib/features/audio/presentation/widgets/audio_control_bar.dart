import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/core/widgets/ui_utils.dart';
import '../../domain/entities/qori.dart';
import '../providers/audio_player_provider.dart';

class AudioControlBar extends ConsumerWidget {
  const AudioControlBar({super.key});

  String _formatDuration(Duration d) {
    final min = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final sec = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  IconData _repeatIcon(RepeatMode mode) {
    switch (mode) {
      case RepeatMode.none:
        return Icons.repeat_rounded;
      case RepeatMode.repeatAyat:
        return Icons.repeat_one_rounded;
      case RepeatMode.repeatSurah:
        return Icons.repeat_on_rounded;
    }
  }

  String _repeatTooltip(RepeatMode mode) {
    switch (mode) {
      case RepeatMode.none:
        return 'Ulangi: Mati';
      case RepeatMode.repeatAyat:
        return 'Ulangi Ayat';
      case RepeatMode.repeatSurah:
        return 'Ulangi Surah';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final audioNotifier = ref.read(audioPlayerProvider.notifier);
    final theme = Theme.of(context);

    // Hide if nothing is actively loaded/playing
    if (audioState.playingSurah == null &&
        audioState.playingAyat == null &&
        !audioState.isLoading) {
      return const SizedBox.shrink();
    }

    final hasProgress = audioState.duration.inMilliseconds > 0;
    final progress = hasProgress
        ? (audioState.position.inMilliseconds /
                audioState.duration.inMilliseconds)
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Seekbar ──
            if (hasProgress)
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 14),
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor:
                      AppColors.primary.withValues(alpha: 0.15),
                  thumbColor: AppColors.primary,
                ),
                child: Slider(
                  value: progress,
                  onChanged: (val) {
                    final newPos = Duration(
                        milliseconds:
                            (val * audioState.duration.inMilliseconds)
                                .toInt());
                    audioNotifier.seekTo(newPos);
                  },
                ),
              ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                  16, hasProgress ? 0 : 12, 16, 4),
              child: Row(
                children: [
                  // ── Info ──
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.music_note_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          audioState.surahName != null
                              ? '${audioState.surahName} - Ayat ${audioState.playingAyat ?? 1}'
                              : 'Surah ${audioState.playingSurah} - Ayat ${audioState.playingAyat ?? 1}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            // Qori selector
                            Consumer(
                              builder: (context, ref, _) {
                                final qoriListAsync =
                                    ref.watch(qoriListProvider);
                                return qoriListAsync.when(
                                  data: (qoris) {
                                    final currentQori =
                                        audioState.selectedQori ??
                                            qoris.first;
                                    return GestureDetector(
                                      onTap: () => _showQoriSelector(
                                          context, ref, qoris, currentQori),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            currentQori.name,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const Icon(Icons.arrow_drop_down,
                                              size: 14,
                                              color: AppColors.primary),
                                        ],
                                      ),
                                    );
                                  },
                                  loading: () => const SizedBox.shrink(),
                                  error: (_, stack) =>
                                      const SizedBox.shrink(),
                                );
                              },
                            ),
                            const Spacer(),
                            // Time
                            if (hasProgress)
                              Text(
                                '${_formatDuration(audioState.position)} / ${_formatDuration(audioState.duration)}',
                                style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: theme.textTheme.bodySmall?.color),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.close_rounded, color: Colors.grey, size: 20),
                    onPressed: () => audioNotifier.stop(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // ── Controls ──
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Repeat button
                  IconButton(
                    icon: Icon(
                      _repeatIcon(audioState.repeatMode),
                      color: audioState.repeatMode != RepeatMode.none
                          ? AppColors.primary
                          : Colors.grey,
                      size: 22,
                    ),
                    tooltip: _repeatTooltip(audioState.repeatMode),
                    onPressed: () => audioNotifier.toggleRepeatMode(),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 8),

                  if (audioState.isLoading) ...[
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary),
                      ),
                    ),
                  ] else ...[
                    Bounceable(
                      onTap: () => audioNotifier.previousAyat(),
                      child: IconButton(
                        icon: const Icon(Icons.skip_previous_rounded,
                            color: AppColors.primary, size: 28),
                        onPressed: null, // Let Bounceable handle tap
                        visualDensity: VisualDensity.compact,
                        disabledColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Bounceable(
                      onTap: () {
                        if (audioState.isPlaying) {
                          audioNotifier.pause();
                        } else {
                          audioNotifier.resume();
                        }
                      },
                      child: IconButton(
                        icon: Icon(
                          audioState.isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_filled_rounded,
                          color: AppColors.primary,
                          size: 44,
                        ),
                        onPressed: null,
                        disabledColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Bounceable(
                      onTap: () => audioNotifier.nextAyat(),
                      child: IconButton(
                        icon: const Icon(Icons.skip_next_rounded,
                            color: AppColors.primary, size: 28),
                        onPressed: null,
                        visualDensity: VisualDensity.compact,
                        disabledColor: AppColors.primary,
                      ),
                    ),
                  ],

                  const SizedBox(width: 8),
                  // Ayat counter
                  if (audioState.totalAyats != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${audioState.playingAyat ?? '-'}/${audioState.totalAyats}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (audioState.isError)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  audioState.errorMessage ?? 'Terjadi kesalahan.',
                  style: GoogleFonts.poppins(
                      color: AppColors.error, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showQoriSelector(BuildContext context, WidgetRef ref,
      List<Qori> qoris, Qori currentQori) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXL)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Pilih Qori (Reciter)',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const Divider(height: 1),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: qoris.length,
                  itemBuilder: (context, index) {
                    final qori = qoris[index];
                    final isSelected = qori.id == currentQori.id;
                    return ListTile(
                      title:
                          Text(qori.name, style: GoogleFonts.poppins()),
                      subtitle: Text(qori.style,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.grey)),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle_rounded,
                              color: AppColors.primary)
                          : null,
                      onTap: () {
                        ref
                            .read(audioPlayerProvider.notifier)
                            .setQori(qori);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
