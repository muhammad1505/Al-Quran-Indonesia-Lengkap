import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/firebase_service.dart';
import '../../domain/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  final FirebaseService _firebaseService;

  SyncRepositoryImpl(this._firebaseService);

  @override
  Stream<User?> get authStateChanges => _firebaseService.authStateChanges;

  @override
  User? get currentUser => _firebaseService.currentUser;

  @override
  Future<User?> signIn() async {
    return await _firebaseService.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _firebaseService.signOut();
  }

  @override
  Future<void> backupData(List<String> bookmarks, Map<String, dynamic>? lastRead) async {
    await _firebaseService.backupData(bookmarks: bookmarks, lastRead: lastRead);
  }

  @override
  Future<Map<String, dynamic>?> restoreData() async {
    return await _firebaseService.restoreData();
  }
}
