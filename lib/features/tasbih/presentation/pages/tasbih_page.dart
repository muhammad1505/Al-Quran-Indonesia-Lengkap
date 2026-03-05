import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/features/tasbih/providers/tasbih_providers.dart';

class TasbihPage extends ConsumerWidget {
  const TasbihPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(tasbihCountProvider);
    final target = ref.watch(tasbihTargetProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progress = (count % target) / target;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasbih Digital',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              HapticFeedback.mediumImpact();
              ref.read(tasbihCountProvider.notifier).reset();
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          ref.read(tasbihCountProvider.notifier).increment();
        },
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Circular Progress ──
              SizedBox(
                width: 220,
                height: 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      height: 220,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: isDark
                            ? AppColors.darkCardBorder
                            : AppColors.cardBorder,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          count.toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Text(
                          'dari $target',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // ── Target Chips ──
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [33, 99, 100]
                    .map((t) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: ChoiceChip(
                            label: Text('$t'),
                            selected: target == t,
                            onSelected: (_) {
                              HapticFeedback.selectionClick();
                              ref.read(tasbihTargetProvider.notifier).state = t;
                              ref.read(tasbihCountProvider.notifier).reset();
                            },
                            selectedColor: AppColors.primarySurface,
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: target == t
                                  ? AppColors.primary
                                  : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 48),

              // ── Instruction ──
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.primarySurface,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusRound),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'KETUK LAYAR UNTUK MENGHITUNG',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
