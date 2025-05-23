import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Mock implementation for demo
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Simulate a successful sign-in
      await Future.delayed(const Duration(seconds: 1));
      
      return {
        'uid': 'user123',
        'email': 'user@example.com',
        'displayName': 'Demo User',
        'photoURL': null,
      };
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> saveUserGoals(String userId, List<String> goals) async {
    try {
      // Save to shared preferences instead of Firebase
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('userGoals', goals);
      debugPrint('Saved goals for user $userId: $goals');
    } catch (e) {
      debugPrint('Error saving user goals: $e');
    }
  }

  Future<void> signOut() async {
    // Clear shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userGoals');
  }
}
