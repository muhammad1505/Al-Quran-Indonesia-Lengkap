import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/features/quran/presentation/widgets/bookmark_tile.dart';
import 'package:quran_app/providers/app_providers.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Bookmark',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          bookmarksAsync.when(
            data: (bookmarks) {
              if (bookmarks.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bookmark_outline_rounded,
                            size: 56,
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.5)),
                        const SizedBox(height: 16),
                        Text('Belum ada bookmark',
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text('Tandai ayat favorit Anda',
                            style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      BookmarkTile(bookmarkId: bookmarks[index]),
                  childCount: bookmarks.length,
                ),
              );
            },
            loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Error: $e'))),
          ),
        ],
      ),
    );
  }
}
