import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Authentication
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Backup Data
  Future<void> backupData({
    required List<String> bookmarks,
    required Map<String, dynamic>? lastRead,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('User belum login');

    final backupData = {
      'userId': user.uid,
      'email': user.email,
      'bookmarks': bookmarks,
      'lastRead': lastRead,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('user_backups')
        .doc(user.uid)
        .set(backupData, SetOptions(merge: true));
  }

  // Restore Data
  Future<Map<String, dynamic>?> restoreData() async {
    final user = currentUser;
    if (user == null) throw Exception('User belum login');

    final docSnapshot =
        await _firestore.collection('user_backups').doc(user.uid).get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    }
    return null;
  }
}
