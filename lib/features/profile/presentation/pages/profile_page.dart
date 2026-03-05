import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/core/theme/app_colors.dart';
import 'package:quran_app/core/providers/settings_provider.dart';
import 'package:quran_app/providers/theme_provider.dart';
import 'package:quran_app/providers/app_providers.dart';
import 'package:quran_app/features/audio/presentation/pages/audio_manager_page.dart';
import 'package:quran_app/features/cloud_sync/presentation/providers/sync_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.watch(settingsProvider);
    final bookmarksAsync = ref.watch(bookmarksProvider);
    final lastReadAsync = ref.watch(lastReadProvider);

    final userAsync = ref.watch(authStateProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Profile Header ──
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, MediaQuery.of(context).padding.top + 24, 16, 24),
              decoration: BoxDecoration(
                gradient: isDark
                    ? AppColors.darkHeaderGradient
                    : AppColors.headerGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: userAsync.when(
                data: (user) => Column(
                  children: [
                    if (user?.photoURL != null)
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user!.photoURL!),
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.2),
                      )
                    else
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 2),
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: Colors.white, size: 44),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      user?.displayName ?? 'Hamba Allah',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    if (user?.email != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user!.email!,
                        style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13),
                      ),
                    ],
                    if (user == null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Login untuk sync data',
                        style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                    ],
                  ],
                ),
                loading: () => Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hamba Allah',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
                error: (_, stack) => Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: Colors.white, size: 44),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hamba Allah',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Cloud Sync (right below profile) ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: const _CloudSyncCard(),
            ),
          ),

          // ── Stats Cards ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.bookmark_rounded,
                      label: 'Bookmark',
                      value: bookmarksAsync.when(
                        data: (b) => b.length.toString(),
                        loading: () => '...',
                        error: (_, stack) => '0',
                      ),
                      color: AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.menu_book_rounded,
                      label: 'Terakhir',
                      value: lastReadAsync.when(
                        data: (d) => d != null
                            ? 'Ayat ${d['ayahNumber']}'
                            : '-',
                        loading: () => '...',
                        error: (_, stack) => '-',
                      ),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Settings Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text('Pengaturan', style: theme.textTheme.headlineSmall),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Column(
                  children: [
                    // Dark Mode Toggle
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.dark_mode_rounded,
                            color: AppColors.accent, size: 22),
                      ),
                      title: Text('Mode Gelap',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      subtitle: Text(
                        themeMode == ThemeMode.dark
                            ? 'Aktif'
                            : themeMode == ThemeMode.light
                                ? 'Nonaktif'
                                : 'Mengikuti sistem',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Switch.adaptive(
                        value: themeMode == ThemeMode.dark,
                        onChanged: (_) =>
                            ref.read(themeModeProvider.notifier).toggle(),
                        activeTrackColor: AppColors.primary,
                      ),
                    ),
                    const Divider(height: 0, indent: 60),
                    // Tajwid Mode Toggle
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.palette_rounded,
                            color: AppColors.accent, size: 22),
                      ),
                      title: Text('Tajwid Berwarna',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      subtitle: Text(
                        settings.isTajwidMode ? 'Aktif' : 'Nonaktif',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Switch.adaptive(
                        value: settings.isTajwidMode,
                        onChanged: (val) => ref
                            .read(settingsProvider.notifier)
                            .toggleTajwidMode(val),
                        activeTrackColor: AppColors.primary,
                      ),
                    ),
                    const Divider(height: 0, indent: 60),
                    // Transliteration Toggle
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.sort_by_alpha_rounded,
                            color: AppColors.success, size: 22),
                      ),
                      title: Text('Tampilkan Transliterasi',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      subtitle: Text(
                        settings.showTransliteration ? 'Aktif' : 'Nonaktif',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Switch.adaptive(
                        value: settings.showTransliteration,
                        onChanged: (val) => ref
                            .read(settingsProvider.notifier)
                            .toggleTransliteration(val),
                        activeTrackColor: AppColors.primary,
                      ),
                    ),
                    const Divider(height: 0, indent: 60),
                    // Rasm Type
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.menu_book_rounded,
                            color: AppColors.warning, size: 22),
                      ),
                      title: Text('Bentuk Rasm',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      subtitle: Text(
                        settings.rasmType == RasmType.utsmani
                            ? 'Utsmani (Standar Madinah)'
                            : 'IndoPak (Standar Indonesia/Kemenag)',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: DropdownButton<RasmType>(
                        value: settings.rasmType,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        onChanged: (RasmType? newValue) {
                          if (newValue != null) {
                            ref
                                .read(settingsProvider.notifier)
                                .setRasmType(newValue);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: RasmType.utsmani,
                            child: Text('Utsmani',
                                style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: RasmType.indoPak,
                            child: Text('IndoPak',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0, indent: 60),
                    // Translation Type
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.translate_rounded,
                            color: AppColors.error, size: 22),
                      ),
                      title: Text('Terjemahan',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      subtitle: Text(
                        settings.translationType == TranslationType.kemenAg
                            ? 'KemenAg-RI'
                            : 'Tafsir Al Jalalain',
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: DropdownButton<TranslationType>(
                        value: settings.translationType,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down_rounded),
                        onChanged: (TranslationType? newValue) {
                          if (newValue != null) {
                            ref
                                .read(settingsProvider.notifier)
                                .setTranslationType(newValue);
                          }
                        },
                        items: const [
                          DropdownMenuItem(
                            value: TranslationType.kemenAg,
                            child: Text('KemenAg',
                                style: TextStyle(fontSize: 14)),
                          ),
                          DropdownMenuItem(
                            value: TranslationType.tafsirJalalain,
                            child: Text('Jalalain',
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0, indent: 60),
                    // Audio Manager
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.library_music_rounded,
                            color: AppColors.primary, size: 22),
                      ),
                      title: Text('Audio Manager',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      subtitle: Text('Kelola unduhan murottal',
                          style: theme.textTheme.bodySmall),
                      trailing: Icon(Icons.chevron_right_rounded,
                          color: theme.textTheme.bodySmall?.color),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AudioManagerPage()));
                      },
                    ),
                    const Divider(height: 0, indent: 60),
                    // Notifications (coming soon)
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: AppColors.info, size: 22),
                      ),
                      title: Text('Notifikasi Adzan',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                      subtitle: Text('Segera hadir',
                          style: theme.textTheme.bodySmall),
                      trailing: Icon(Icons.chevron_right_rounded,
                          color: theme.textTheme.bodySmall?.color),
                    ),
                  ],
                ),
              ),
            ),
          ),



          // ── About Section ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Tentang', style: theme.textTheme.headlineSmall),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Column(
                  children: [
                    _AboutTile(
                      icon: Icons.info_outline_rounded,
                      label: 'Versi Aplikasi',
                      trailing: Text('1.0.0',
                          style: theme.textTheme.bodyMedium),
                    ),
                    const Divider(height: 0, indent: 60),
                    _AboutTile(
                      icon: Icons.star_outline_rounded,
                      label: 'Beri Rating',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Segera hadir!')),
                      ),
                    ),
                    const Divider(height: 0, indent: 60),
                    _AboutTile(
                      icon: Icons.share_outlined,
                      label: 'Bagikan Aplikasi',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Segera hadir!')),
                      ),
                    ),
                    const Divider(height: 0, indent: 60),
                    _AboutTile(
                      icon: Icons.favorite_outline_rounded,
                      label: 'Kontribusi',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Terima kasih!')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                'Dibuat dengan ❤️ untuk umat Islam',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color)),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _AboutTile({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: theme.textTheme.bodyMedium?.color, size: 22),
      ),
      title: Text(label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15)),
      trailing: trailing ??
          Icon(Icons.chevron_right_rounded,
              color: theme.textTheme.bodySmall?.color),
      onTap: onTap,
    );
  }
}

class _CloudSyncCard extends ConsumerWidget {
  const _CloudSyncCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(authStateProvider);
    final syncState = ref.watch(syncProvider);

    ref.listen<SyncState>(syncProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!), backgroundColor: AppColors.error),
        );
      }
      if (next.successMessage != null && next.successMessage != previous?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!), backgroundColor: AppColors.success),
        );
      }
    });

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Simpan riwayat bacaan terakhir dan bookmark Anda ke Cloud agar tidak hilang saat berganti perangkat.',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: syncState.isLoading
                        ? null
                        : () => ref.read(syncProvider.notifier).signIn(),
                    icon: const Icon(Icons.login_rounded),
                    label: Text(syncState.isLoading ? 'Menghubungkan...' : 'Login dengan Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tersinkronisasi dengan ${user.email ?? "akun Google"}',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.success),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: syncState.isLoading
                            ? null
                            : () async {
                                final bookmarks = await ref.read(bookmarksProvider.future);
                                final lastRead = await ref.read(lastReadProvider.future);
                                ref.read(syncProvider.notifier).backup(bookmarks, lastRead);
                              },
                        icon: const Icon(Icons.cloud_upload_rounded),
                        label: const Text('Backup'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: syncState.isLoading
                            ? null
                            : () async {
                                final data = await ref.read(syncProvider.notifier).restore();
                                if (data != null) {
                                  final localStorage = ref.read(localStorageServiceProvider);
                                  final remoteBookmarks = List<String>.from(data['bookmarks'] ?? []);
                                  await localStorage.clearBookmarks();
                                  for (var rm in remoteBookmarks) {
                                      await localStorage.addBookmark(rm);
                                  }

                                  if (data['lastRead'] != null) {
                                    final lr = data['lastRead'] as Map<String, dynamic>;
                                    await localStorage.saveLastRead(
                                      surahNumber: lr['surahNumber'],
                                      ayahNumber: lr['ayahNumber'],
                                      surahName: lr['surahName'],
                                    );
                                  }
                                  
                                  ref.invalidate(bookmarksProvider);
                                  ref.invalidate(lastReadProvider);
                                }
                              },
                        icon: const Icon(Icons.cloud_download_rounded),
                        label: const Text('Restore'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: syncState.isLoading
                        ? null
                        : () => ref.read(syncProvider.notifier).signOut(),
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text('Logout'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
                if (syncState.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, stack) => Text('Terjadi kesalahan otentikasi', style: TextStyle(color: AppColors.error)),
        ),
      ),
    );
  }
}
