import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/qori.dart';
import '../../domain/repositories/audio_repository.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';
import 'audio_player_provider.dart';

class AudioDownloadState {
  final Map<int, double> downloadingProgress;
  final Set<int> downloadedSurahs;
  final Qori? currentQori;

  const AudioDownloadState({
    this.downloadingProgress = const {},
    this.downloadedSurahs = const {},
    this.currentQori,
  });

  AudioDownloadState copyWith({
    Map<int, double>? downloadingProgress,
    Set<int>? downloadedSurahs,
    Qori? currentQori,
  }) {
    return AudioDownloadState(
      downloadingProgress: downloadingProgress ?? this.downloadingProgress,
      downloadedSurahs: downloadedSurahs ?? this.downloadedSurahs,
      currentQori: currentQori ?? this.currentQori,
    );
  }
}

class AudioDownloadNotifier extends StateNotifier<AudioDownloadState> {
  final AudioRepository _repository;
  final Ref _ref;

  AudioDownloadNotifier(this._repository, this._ref) : super(const AudioDownloadState());

  Future<void> init(Qori qori) async {
    state = state.copyWith(currentQori: qori);
    await refreshDownloadedSurahs();
  }

  Future<void> refreshDownloadedSurahs() async {
    if (state.currentQori == null) return;
    
    final surahs = await _ref.read(surahListProvider.future);
    
    final downloaded = <int>{};
    for (final surah in surahs) {
      final isDownloaded = await _repository.isSurahDownloaded(state.currentQori!, surah.number, surah.totalVerses);
      if (isDownloaded) {
        downloaded.add(surah.number);
      }
    }
    
    state = state.copyWith(downloadedSurahs: downloaded);
  }

  Future<void> downloadSurah(int surahNumber) async {
    if (state.currentQori == null) return;
    
    final qori = state.currentQori!;
    final surahsList = await _ref.read(surahListProvider.future);
    
    final surah = surahsList.firstWhere((s) => s.number == surahNumber);

    state = state.copyWith(
      downloadingProgress: {
        ...state.downloadingProgress,
        surahNumber: 0.0,
      },
    );

    try {
      await _repository.downloadSurah(
        qori,
        surahNumber,
        surah.totalVerses,
        onProgress: (completed, total) {
          if (total > 0) {
            final progress = completed / total;
            state = state.copyWith(
              downloadingProgress: {
                ...state.downloadingProgress,
                surahNumber: progress,
              },
            );
          }
        },
      );

      // Download complete
      final newProgress = Map<int, double>.from(state.downloadingProgress)..remove(surahNumber);
      final newDownloaded = Set<int>.from(state.downloadedSurahs)..add(surahNumber);
      
      state = state.copyWith(
        downloadingProgress: newProgress,
        downloadedSurahs: newDownloaded,
      );
    } catch (e) {
      // Handle error by removing from progress
      final newProgress = Map<int, double>.from(state.downloadingProgress)..remove(surahNumber);
      state = state.copyWith(downloadingProgress: newProgress);
    }
  }

  Future<void> deleteSurah(int surahNumber) async {
    if (state.currentQori == null) return;
    
    final surahsList = await _ref.read(surahListProvider.future);
    
    final surah = surahsList.firstWhere((s) => s.number == surahNumber);
    
    await _repository.deleteSurah(state.currentQori!, surahNumber, surah.totalVerses);
    
    final newDownloaded = Set<int>.from(state.downloadedSurahs)..remove(surahNumber);
    state = state.copyWith(downloadedSurahs: newDownloaded);
  }
}

// Provider that automatically updates when the selected Qori changes
final audioDownloadProvider = StateNotifierProvider<AudioDownloadNotifier, AudioDownloadState>((ref) {
  final repo = ref.watch(audioRepositoryProvider);
  final notifier = AudioDownloadNotifier(repo, ref);

  // Watch the selected Qori from the AudioPlayer state
  final selectedQori = ref.watch(audioPlayerProvider.select((s) => s.selectedQori));
  
  if (selectedQori != null) {
    notifier.init(selectedQori);
  } else {
    // If null, try to get the first one from the list provider as a default
    ref.listen<AsyncValue<List<Qori>>>(qoriListProvider, (previous, next) {
      if (next.hasValue && next.value!.isNotEmpty) {
        final defaultQori = next.value!.first;
        notifier.init(defaultQori);
      }
    }, fireImmediately: true);
  }

  return notifier;
});
