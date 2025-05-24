// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/user_provider.dart';
import 'services/comfort_data_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Providers wrap the entire MaterialApp
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<ComfortDataProvider>(
          create: (_) => ComfortDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ComfortCrash',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashScreen(), // Start here
      ),
    );
  }
}
