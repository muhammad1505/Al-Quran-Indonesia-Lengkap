import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/features/doa/domain/entities/doa.dart';

class DoaListCard extends StatefulWidget {
  final Doa doa;

  const DoaListCard({super.key, required this.doa});

  @override
  State<DoaListCard> createState() => _DoaListCardState();
}

class _DoaListCardState extends State<DoaListCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doa = widget.doa;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.radiusLG),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Title ──
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        doa.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: AppConstants.animFast,
                      child: Icon(Icons.expand_more_rounded,
                          color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // ── Arabic Text ──
                Text(
                  doa.arabic,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    height: 2.0,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),

                // ── Expandable section ──
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Divider(
                          color: theme.colorScheme.outline
                              .withValues(alpha: 0.3)),
                      const SizedBox(height: 8),

                      // Latin
                      if (doa.latin.isNotEmpty) ...[
                        Text(
                          doa.latin,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: theme.textTheme.bodyMedium?.color,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Translation
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.06),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMD),
                        ),
                        child: Text(
                          doa.translation,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: theme.textTheme.bodyLarge?.color,
                            height: 1.5,
                          ),
                        ),
                      ),

                      // Notes
                      if (doa.notes != null && doa.notes!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          doa.notes!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: theme.textTheme.bodySmall?.color,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: AppConstants.animMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
