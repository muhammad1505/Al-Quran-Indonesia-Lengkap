import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/constants/app_constants.dart';
import 'package:quran_app/features/quran/presentation/pages/bookmarks_page.dart';
import 'package:quran_app/features/quran/presentation/pages/surah_page_view.dart';
import 'package:quran_app/features/quran/presentation/widgets/surah_list_tile.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';
import 'package:quran_app/shared/widgets/shimmer_loading.dart';

class QuranPage extends ConsumerStatefulWidget {
  const QuranPage({super.key});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  String _filterType = 'all'; // 'all', 'meccan', 'medinan'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Search bar is only relevant for Surah tab
    final bool showSearch = _tabController.index == 0;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(
                'Al-Qur\'an',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmark_outline_rounded),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const BookmarksPage())),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(showSearch ? 120 : 48),
                child: Column(
                  children: [
                    Visibility(
                      visible: showSearch,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkCard
                                : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (q) =>
                                ref.read(searchQueryProvider.notifier).update(q),
                            style: GoogleFonts.poppins(fontSize: 14),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search_rounded,
                                  color: theme.textTheme.bodySmall?.color, size: 22),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.close_rounded,
                                          color: theme.textTheme.bodySmall?.color,
                                          size: 20),
                                      onPressed: () {
                                        _searchController.clear();
                                        ref
                                            .read(searchQueryProvider.notifier)
                                            .update('');
                                        setState(() {});
                                      },
                                    )
                                  : null,
                              hintText: 'Cari surah...',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14, color: theme.textTheme.bodySmall?.color),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tab Bar
                    TabBar(
                      controller: _tabController,
                      labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 14),
                      unselectedLabelStyle:
                          GoogleFonts.poppins(fontSize: 14),
                      indicatorSize: TabBarIndicatorSize.label,
                      dividerHeight: 0,
                      tabs: const [
                        Tab(text: 'Surah'),
                        Tab(text: 'Juz'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _SurahListTab(
              filterType: _filterType,
              onFilterChanged: (f) => setState(() => _filterType = f),
            ),
            const _JuzListTab(),
          ],
        ),
      ),
    );
  }
}

// ── Surah List Tab ──
class _SurahListTab extends ConsumerWidget {
  final String filterType;
  final ValueChanged<String> onFilterChanged;

  const _SurahListTab({
    required this.filterType,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(filteredSurahsProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Filter Chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            children: [
              _FilterChip(
                label: 'Semua',
                selected: filterType == 'all',
                onTap: () => onFilterChanged('all'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Makkiyah',
                selected: filterType == 'meccan',
                onTap: () => onFilterChanged('meccan'),
              ),
              const SizedBox(width: 8),
              _FilterChip(
                label: 'Madaniyah',
                selected: filterType == 'medinan',
                onTap: () => onFilterChanged('medinan'),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: surahsAsync.when(
            data: (surahs) {
              final filtered = filterType == 'all'
                  ? surahs
                  : surahs
                      .where((s) =>
                          s.revelationType.toLowerCase() == filterType)
                      .toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 48, color: theme.textTheme.bodySmall?.color),
                      const SizedBox(height: 12),
                      Text('Surah tidak ditemukan',
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 80),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final surah = filtered[index];
                  return SurahListTile(
                    surah: surah,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SurahPageView(
                            initialSurahNumber: surah.number,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.only(top: 16),
              child: ShimmerSurahList(),
            ),
            error: (e, _) => Center(
              child: Text('Gagal memuat surah: $e'),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Filter Chip ──
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppConstants.radiusRound),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Theme.of(context).colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ),
    );
  }
}

// ── Juz List Tab ──
class _JuzListTab extends ConsumerWidget {
  const _JuzListTab();

  // Juz to starting surah mapping
  static const List<Map<String, dynamic>> _juzData = [
    {'juz': 1, 'start': 'Al-Fatihah 1', 'end': 'Al-Baqarah 141'},
    {'juz': 2, 'start': 'Al-Baqarah 142', 'end': 'Al-Baqarah 252'},
    {'juz': 3, 'start': 'Al-Baqarah 253', 'end': 'Ali Imran 92'},
    {'juz': 4, 'start': 'Ali Imran 93', 'end': 'An-Nisa 23'},
    {'juz': 5, 'start': 'An-Nisa 24', 'end': 'An-Nisa 147'},
    {'juz': 6, 'start': 'An-Nisa 148', 'end': 'Al-Maidah 81'},
    {'juz': 7, 'start': 'Al-Maidah 82', 'end': 'Al-An\'am 110'},
    {'juz': 8, 'start': 'Al-An\'am 111', 'end': 'Al-A\'raf 87'},
    {'juz': 9, 'start': 'Al-A\'raf 88', 'end': 'Al-Anfal 40'},
    {'juz': 10, 'start': 'Al-Anfal 41', 'end': 'At-Tawbah 92'},
    {'juz': 11, 'start': 'At-Tawbah 93', 'end': 'Hud 5'},
    {'juz': 12, 'start': 'Hud 6', 'end': 'Yusuf 52'},
    {'juz': 13, 'start': 'Yusuf 53', 'end': 'Ibrahim 52'},
    {'juz': 14, 'start': 'Al-Hijr 1', 'end': 'An-Nahl 128'},
    {'juz': 15, 'start': 'Al-Isra 1', 'end': 'Al-Kahf 74'},
    {'juz': 16, 'start': 'Al-Kahf 75', 'end': 'Taha 135'},
    {'juz': 17, 'start': 'Al-Anbya 1', 'end': 'Al-Hajj 78'},
    {'juz': 18, 'start': 'Al-Mu\'minun 1', 'end': 'Al-Furqan 20'},
    {'juz': 19, 'start': 'Al-Furqan 21', 'end': 'An-Naml 55'},
    {'juz': 20, 'start': 'An-Naml 56', 'end': 'Al-Ankabut 45'},
    {'juz': 21, 'start': 'Al-Ankabut 46', 'end': 'Al-Ahzab 30'},
    {'juz': 22, 'start': 'Al-Ahzab 31', 'end': 'Ya-Sin 27'},
    {'juz': 23, 'start': 'Ya-Sin 28', 'end': 'Az-Zumar 31'},
    {'juz': 24, 'start': 'Az-Zumar 32', 'end': 'Fussilat 46'},
    {'juz': 25, 'start': 'Fussilat 47', 'end': 'Al-Jathiyah 37'},
    {'juz': 26, 'start': 'Al-Ahqaf 1', 'end': 'Adh-Dhariyat 30'},
    {'juz': 27, 'start': 'Adh-Dhariyat 31', 'end': 'Al-Hadid 29'},
    {'juz': 28, 'start': 'Al-Mujadila 1', 'end': 'At-Tahrim 12'},
    {'juz': 29, 'start': 'Al-Mulk 1', 'end': 'Al-Mursalat 50'},
    {'juz': 30, 'start': 'An-Naba 1', 'end': 'An-Nas 6'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: 30,
      itemBuilder: (context, index) {
        final juz = _juzData[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              onTap: () {
                // Navigate to first surah of this juz
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Juz ${juz['juz']} - Segera hadir')),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '${juz['juz']}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Juz ${juz['juz']}',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${juz['start']} — ${juz['end']}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        color: theme.textTheme.bodySmall?.color),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
