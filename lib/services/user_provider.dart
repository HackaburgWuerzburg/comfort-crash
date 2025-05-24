// lib/providers/user_provider.dart

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Exposes FirebaseAuth’s current user and login state.
class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  UserProvider() {
    // Initialize with the currently signed-in user (if any)
    _user = _auth.currentUser;
    // Listen for future auth state changes
    _auth.userChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  /// The currently signed-in Firebase user, or null.
  User? get user => _user;

  /// True if there is a signed-in user.
  bool get isLoggedIn => _user != null;

  /// Sign in anonymously (example).
  Future<UserCredential> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
    // _user will be set to null by the userChanges listener
  }
}
