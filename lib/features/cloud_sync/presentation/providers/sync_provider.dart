import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/firebase_service.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../data/repositories/sync_repository_impl.dart';

// Providers for dependencies
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepositoryImpl(ref.watch(firebaseServiceProvider));
});

// Stream provider to track Authentication state (loggedIn or not)
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(syncRepositoryProvider).authStateChanges;
});

class SyncState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String? successMessage;

  const SyncState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.successMessage,
  });

  SyncState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) {
    return SyncState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class SyncNotifier extends StateNotifier<SyncState> {
  final SyncRepository _repository;

  SyncNotifier(this._repository) : super(const SyncState());

  Future<void> signIn() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await _repository.signIn();
      state = state.copyWith(isLoading: false, isSuccess: true, successMessage: 'Login berhasil');
    } catch (e) {
      state = state.copyWith(
          isLoading: false,
          errorMessage: 'Gagal login. Pastikan koneksi internet stabil.');
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await _repository.signOut();
      state = state.copyWith(isLoading: false, isSuccess: true, successMessage: 'Logout berhasil');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Gagal logout.');
    }
  }

  Future<void> backup(List<String> bookmarks, Map<String, dynamic>? lastRead) async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      await _repository.backupData(bookmarks, lastRead);
      state = state.copyWith(isLoading: false, isSuccess: true, successMessage: 'Data berhasil dibackup ke Cloud');
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Gagal melakukan backup.');
    }
  }

  Future<Map<String, dynamic>?> restore() async {
    state = state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    try {
      final data = await _repository.restoreData();
      state = state.copyWith(isLoading: false, isSuccess: true, successMessage: 'Data berhasil dipulihkan dari Cloud');
      return data;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Gagal memulihkan data.');
      return null;
    }
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.watch(syncRepositoryProvider));
});
