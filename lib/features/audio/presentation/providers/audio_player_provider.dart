import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/qori.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../data/repositories/audio_repository_impl.dart';
import 'package:quran_app/features/quran/providers/surah_providers.dart';

// Provides the repository
final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepositoryImpl();
});

// Provides the list of available Qoris
final qoriListProvider = FutureProvider<List<Qori>>((ref) async {
  final repo = ref.watch(audioRepositoryProvider);
  return repo.getAvailableQoris();
});

enum RepeatMode { none, repeatAyat, repeatSurah }

// State class for AudioPlayer
class AudioPlayerState {
  final bool isPlaying;
  final bool isLoading;
  final bool isError;
  final String? errorMessage;
  final Qori? selectedQori;
  final int? playingSurah;
  final int? playingAyat;
  final int? totalAyats;
  final String? surahName;
  final Duration position;
  final Duration duration;
  final RepeatMode repeatMode;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isLoading = false,
    this.isError = false,
    this.errorMessage,
    this.selectedQori,
    this.playingSurah,
    this.playingAyat,
    this.totalAyats,
    this.surahName,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.repeatMode = RepeatMode.none,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    Qori? selectedQori,
    int? playingSurah,
    int? playingAyat,
    int? totalAyats,
    String? surahName,
    Duration? position,
    Duration? duration,
    RepeatMode? repeatMode,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedQori: selectedQori ?? this.selectedQori,
      playingSurah: playingSurah ?? this.playingSurah,
      playingAyat: playingAyat ?? this.playingAyat,
      totalAyats: totalAyats ?? this.totalAyats,
      surahName: surahName ?? this.surahName,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      repeatMode: repeatMode ?? this.repeatMode,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioRepository _repository;
  final Ref _ref;
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerNotifier(this._repository, this._ref) : super(const AudioPlayerState()) {
    // Listen to player state
    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;

      bool isLoading = processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering;

      if (processingState == ProcessingState.completed) {
        _onCompleted();
      } else {
        state = state.copyWith(
          isPlaying: isPlaying,
          isLoading: isLoading,
          isError: false,
          errorMessage: null,
        );
      }
    });

    // Position stream
    _player.positionStream.listen((pos) {
      if (mounted) {
        state = state.copyWith(position: pos);
      }
    });

    // Duration stream
    _player.durationStream.listen((dur) {
      if (mounted && dur != null) {
        state = state.copyWith(duration: dur);
      }
    });

    // Error stream
    _player.playbackEventStream.listen((_) {}, onError: (Object e, StackTrace _) {
      state = state.copyWith(
        isError: true,
        isLoading: false,
        isPlaying: false,
        errorMessage: 'Gagal memutar audio.',
      );
    });
  }

  void _onCompleted() {
    switch (state.repeatMode) {
      case RepeatMode.repeatAyat:
        // Replay the same ayat
        if (state.playingSurah != null && state.playingAyat != null) {
          playAyat(state.playingSurah!, state.playingAyat!,
              totalAyats: state.totalAyats, surahName: state.surahName);
        }
        break;
      case RepeatMode.repeatSurah:
        // Go to next ayat, loop back to ayat 1 at end
        if (state.playingSurah != null &&
            state.playingAyat != null &&
            state.totalAyats != null) {
          final nextAyat = state.playingAyat! < state.totalAyats!
              ? state.playingAyat! + 1
              : 1; // loop back
          playAyat(state.playingSurah!, nextAyat,
              totalAyats: state.totalAyats, surahName: state.surahName);
        }
        break;
      case RepeatMode.none:
        // Auto-advance to next ayat/surah
        if (state.playingSurah != null &&
            state.playingAyat != null &&
            state.totalAyats != null) {
          if (state.playingAyat! < state.totalAyats!) {
            playAyat(state.playingSurah!, state.playingAyat! + 1,
                totalAyats: state.totalAyats, surahName: state.surahName);
          } else if (state.playingSurah! < 114) {
            final nextSurahNumber = state.playingSurah! + 1;
            _ref.read(surahListProvider.future).then((surahs) {
              final nextSurah =
                  surahs.firstWhere((s) => s.number == nextSurahNumber);
              playAyat(nextSurahNumber, 1,
                  totalAyats: nextSurah.totalVerses,
                  surahName: nextSurah.name);
            });
          } else {
            state = state.copyWith(isPlaying: false, isLoading: false);
          }
        } else {
          state = state.copyWith(isPlaying: false, isLoading: false);
        }
        break;
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void setQori(Qori qori) {
    state = state.copyWith(selectedQori: qori);
    if (state.playingSurah != null && state.playingAyat != null) {
      playAyat(state.playingSurah!, state.playingAyat!,
          totalAyats: state.totalAyats, surahName: state.surahName);
    }
  }

  void toggleRepeatMode() {
    final next = RepeatMode.values[
        (state.repeatMode.index + 1) % RepeatMode.values.length];
    state = state.copyWith(repeatMode: next);
  }

  Future<void> playSurah(int surahNumber) async {
    _ref.read(surahListProvider.future).then((surahs) {
      final surah = surahs.firstWhere((s) => s.number == surahNumber);
      playAyat(surahNumber, 1,
          totalAyats: surah.totalVerses, surahName: surah.name);
    }).catchError((e) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: 'Gagal memuat Surah audio.',
      );
    });
  }

  Future<void> playAyat(int surahNumber, int ayatNumber,
      {int? totalAyats, String? surahName}) async {
    final qoris = await _repository.getAvailableQoris();
    final qori = state.selectedQori ?? qoris.first;

    final localPath =
        await _repository.getLocalAyatPath(qori, surahNumber, ayatNumber);
    final url =
        localPath ?? _repository.getAyatAudioUrl(qori, surahNumber, ayatNumber);

    // Resolve surah name if not provided
    String? resolvedName = surahName ?? state.surahName;
    if (resolvedName == null) {
      try {
        final surahs = await _ref.read(surahListProvider.future);
        resolvedName =
            surahs.firstWhere((s) => s.number == surahNumber).name;
      } catch (_) {
        resolvedName = 'Surah $surahNumber';
      }
    }

    state = state.copyWith(
      selectedQori: qori,
      playingSurah: surahNumber,
      playingAyat: ayatNumber,
      totalAyats: totalAyats ?? state.totalAyats,
      surahName: resolvedName,
      isLoading: true,
      isError: false,
      position: Duration.zero,
      duration: Duration.zero,
    );

    try {
      if (localPath != null) {
        await _player.setFilePath(localPath);
      } else {
        await _player.setUrl(url);
      }
      _player.play();
    } catch (e) {
      state = state.copyWith(
        isError: true,
        isLoading: false,
        errorMessage: 'Gagal memutar ayat.',
      );
    }
  }

  void nextAyat() {
    if (state.playingSurah != null &&
        state.playingAyat != null &&
        state.totalAyats != null) {
      if (state.playingAyat! < state.totalAyats!) {
        playAyat(state.playingSurah!, state.playingAyat! + 1,
            totalAyats: state.totalAyats, surahName: state.surahName);
      } else if (state.playingSurah! < 114) {
        final nextSurahNumber = state.playingSurah! + 1;
        _ref.read(surahListProvider.future).then((surahs) {
          final nextSurah =
              surahs.firstWhere((s) => s.number == nextSurahNumber);
          playAyat(nextSurahNumber, 1,
              totalAyats: nextSurah.totalVerses, surahName: nextSurah.name);
        });
      }
    }
  }

  void previousAyat() {
    if (state.playingSurah != null && state.playingAyat != null) {
      if (state.playingAyat! > 1) {
        playAyat(state.playingSurah!, state.playingAyat! - 1,
            totalAyats: state.totalAyats, surahName: state.surahName);
      } else if (state.playingSurah! > 1) {
        final prevSurahNumber = state.playingSurah! - 1;
        _ref.read(surahListProvider.future).then((surahs) {
          final prevSurah =
              surahs.firstWhere((s) => s.number == prevSurahNumber);
          playAyat(prevSurahNumber, prevSurah.totalVerses,
              totalAyats: prevSurah.totalVerses, surahName: prevSurah.name);
        });
      }
    }
  }

  void seekTo(Duration position) {
    _player.seek(position);
  }

  void pause() {
    _player.pause();
  }

  void resume() {
    _player.play();
  }

  void stop() {
    _player.stop();
    state = const AudioPlayerState();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  final repository = ref.watch(audioRepositoryProvider);
  return AudioPlayerNotifier(repository, ref);
});
