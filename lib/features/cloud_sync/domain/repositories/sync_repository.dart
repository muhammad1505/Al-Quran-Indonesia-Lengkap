import 'package:firebase_auth/firebase_auth.dart';

abstract class SyncRepository {
  Stream<User?> get authStateChanges;
  User? get currentUser;
  
  Future<User?> signIn();
  Future<void> signOut();
  Future<void> backupData(List<String> bookmarks, Map<String, dynamic>? lastRead);
  Future<Map<String, dynamic>?> restoreData();
}
