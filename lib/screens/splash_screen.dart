// lib/screens/splash_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'auth_screen.dart';
import 'home_screen.dart';
import '../widgets/main_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait until after first frame so context.watch() can be used
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goNext();
    });
  }

  Future<void> _goNext() async {
    // Simulate loading (e.g. fetching config, checking auth)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final userProvider = context.read<UserProvider>();
    final loggedIn = userProvider.isLoggedIn;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
        loggedIn ? const MainScaffold() : const AuthScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use fromRGBO instead of withOpacity()
      backgroundColor: const Color.fromRGBO(0, 123, 255, 0.5),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Your logo or app name
            Icon(
              Icons.water_drop,
              size: 100,
              color: const Color.fromRGBO(255, 255, 255, 0.9),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(255, 255, 255, 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
