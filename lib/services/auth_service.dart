import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get getCurrentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? senderName,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null && senderName != null) {
      await userCredential.user!.updateDisplayName(
        senderName,
      );
    }
    return userCredential;
  }

  Future signinUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOutUserWithEmailAndPassword() async {
    await _firebaseAuth.signOut();
  }
}
