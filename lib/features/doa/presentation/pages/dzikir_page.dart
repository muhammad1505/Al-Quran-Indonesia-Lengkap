import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/features/doa/domain/entities/doa.dart';
import 'package:quran_app/features/doa/presentation/widgets/doa_list_card.dart';
import 'package:quran_app/features/doa/providers/doa_providers.dart';

class DzikirPage extends StatelessWidget {
  const DzikirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dzikir Pagi & Petang'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Pagi'),
              Tab(text: 'Petang'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _DzikirListView(provider: dzikirPagiProvider),
            _DzikirListView(provider: dzikirPetangProvider),
          ],
        ),
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
        itemCount: dzikirs.length,
        itemBuilder: (context, index) {
          return DoaListCard(doa: dzikirs[index]);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Failed to load data: $e')),
    );
  }
}
