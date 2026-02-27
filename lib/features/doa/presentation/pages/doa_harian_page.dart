import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/features/doa/presentation/widgets/doa_list_card.dart';
import 'package:quran_app/features/doa/providers/doa_providers.dart';

class DoaHarianPage extends ConsumerWidget {
  const DoaHarianPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doaHarianAsync = ref.watch(doaHarianProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doa Sehari-hari'),
      ),
      body: doaHarianAsync.when(
        data: (doas) => ListView.builder(
          itemCount: doas.length,
          itemBuilder: (context, index) {
            return DoaListCard(doa: doas[index]);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Failed to load data: $e')),
      ),
    );
  }
}
