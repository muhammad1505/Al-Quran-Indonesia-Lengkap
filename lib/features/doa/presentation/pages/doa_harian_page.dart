import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/features/doa/presentation/widgets/doa_list_card.dart';
import 'package:quran_app/features/doa/providers/doa_providers.dart';
import 'package:quran_app/shared/widgets/shimmer_loading.dart';

class DoaHarianPage extends ConsumerWidget {
  const DoaHarianPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doaHarianAsync = ref.watch(doaHarianProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Doa Sehari-hari',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          doaHarianAsync.when(
            data: (doas) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => DoaListCard(doa: doas[index]),
                childCount: doas.length,
              ),
            ),
            loading: () => SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ShimmerSurahList(count: 5),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: 12),
                    Text('Gagal memuat data: $e',
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
