import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';

class BookmarkTile extends ConsumerWidget {
  final String bookmarkId;

  const BookmarkTile({super.key, required this.bookmarkId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final parts = bookmarkId.split(':');
      final surahNumber = int.parse(parts[0]);
      final ayahNumber = int.parse(parts[1]);

      final surahDetailAsync = ref.watch(surahDetailProvider(surahNumber));

      return surahDetailAsync.when(
        data: (detail) {
          final verse = detail.verses.firstWhere((v) => v.number == ayahNumber);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${detail.transliterationEn}, Verse $ayahNumber',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    verse.text,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.amiri(fontSize: 22, height: 1.8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    verse.translationEn,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const ListTile(title: Text('Loading bookmark...')),
        error: (e, s) => ListTile(title: Text('Error loading verse: $bookmarkId')),
      );
    } catch (e) {
      return ListTile(
        title: Text('Invalid bookmark ID: $bookmarkId'),
        textColor: Colors.red,
      );
    }
  }
}
