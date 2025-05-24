// lib/providers/user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A ChangeNotifier that exposes Firebase authentication state and user info.
class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  UserProvider() {
    // Initialize with any already‐signed‐in user.
    _user = _auth.currentUser;

    // Listen for future auth state changes.
    _auth.userChanges().listen((newUser) {
      _user = newUser;
      notifyListeners();
    });
  }

  /// The currently signed‐in Firebase user, or null if none.
  User? get user => _user;

  /// True if a user is signed in.
  bool get isLoggedIn => _user != null;

  /// Manually update the current user (e.g. after a custom sign-in flow).
  void setUser(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  /// Example: Sign in anonymously.
  Future<UserCredential> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  /// Example: Sign in with Google Popup (web) or other methods.
  Future<UserCredential> signInWithGoogle() async {
    // TODO: implement your Google sign-in flow here.
    // On web you might use `signInWithPopup(GoogleAuthProvider())`.
    throw UnimplementedError('Google sign-in not yet implemented');
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
    // _auth.userChanges listener will pick up the null user and notify.
  }
}
