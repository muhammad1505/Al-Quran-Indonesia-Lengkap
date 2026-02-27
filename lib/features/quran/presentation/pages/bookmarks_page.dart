import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/features/quran/presentation/widgets/bookmark_tile.dart';
import 'package:quran_app/providers/app_providers.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarked Verses'),
      ),
      body: bookmarksAsync.when(
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return const Center(
              child: Text('You have no bookmarked verses yet.'),
            );
          }
          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmarkId = bookmarks[index];
              return BookmarkTile(bookmarkId: bookmarkId);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Failed to load bookmarks: $e')),
      ),
    );
  }
}
