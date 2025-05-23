import 'package:flutter/material.dart';
import 'package:comfort_crash/theme/app_theme.dart';
import 'package:comfort_crash/screens/home_screen.dart';
import 'package:comfort_crash/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  final List<String> selectedGoals;

  const AuthScreen({
    super.key,
    required this.selectedGoals,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Create a mock user without Firebase
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      
      // Create a mock user
      final mockUser = {
        'uid': 'user123',
        'email': 'user@example.com',
        'displayName': 'Demo User',
        'photoURL': null,
      };
      
      // Save selected goals (just print them for now)
      debugPrint('Selected goals: ${widget.selectedGoals}');
      
      // Update user provider
      userProvider.setUser(mockUser);
      
      // Save first time status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFirstTime', false);
      
      // Save goals to shared preferences
      await prefs.setStringList('userGoals', widget.selectedGoals);
      
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_open,
                size: 80,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 30),
              Text(
                'Almost there!',
                style: AppTheme.headingStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Sign in to track your progress and sync your data across devices.',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(
                    Icons.login,
                    color: Colors.black87,
                  ),
                  label: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          'Sign in with Google',
                          style: AppTheme.buttonTextStyle.copyWith(
                            color: Colors.black87,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  // Skip sign in for now
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isFirstTime', false);
                  
                  // Save goals to shared preferences
                  await prefs.setStringList('userGoals', widget.selectedGoals);
                  
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  }
                },
                child: Text(
                  'Skip for now',
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
