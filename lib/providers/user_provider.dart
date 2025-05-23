import 'package:flutter/material.dart';

class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  User({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
    );
  }
}

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  Future<void> checkUserLoggedIn() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For demo purposes, we'll just set a null user
      _user = null;
    } catch (e) {
      debugPrint('Error checking user login status: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUser(Map<String, dynamic> userData) {
    _user = User.fromMap(userData);
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For demo purposes, just set user to null
      _user = null;
    } catch (e) {
      debugPrint('Error signing out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
