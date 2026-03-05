import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/features/doa/domain/entities/doa.dart';
import 'package:quran_app/features/doa/presentation/widgets/doa_list_card.dart';
import 'package:quran_app/features/doa/providers/doa_providers.dart';
import 'package:quran_app/shared/widgets/shimmer_loading.dart';

class DzikirPage extends StatelessWidget {
  const DzikirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            pinned: true,
            title: Text('Dzikir Pagi & Petang',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
        ],
        body: _DzikirListView(provider: dzikirPagiProvider),
      ),
    );
  }
}

class _DzikirListView extends ConsumerWidget {
  final AutoDisposeFutureProvider<List<Doa>> provider;

  const _DzikirListView({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dzikirAsync = ref.watch(provider);
    return dzikirAsync.when(
      data: (dzikirs) => ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: dzikirs.length,
        itemBuilder: (context, index) =>
            DoaListCard(doa: dzikirs[index]),
      ),
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 16),
        child: ShimmerSurahList(count: 5),
      ),
      error: (e, _) => Center(
        child: Text('Gagal memuat data: $e'),
      ),
    );
  }
}
