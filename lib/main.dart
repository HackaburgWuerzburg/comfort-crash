import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:comfort_crash/providers/user_provider.dart';
import 'package:comfort_crash/providers/comfort_data_provider.dart';
import 'package:comfort_crash/screens/splash_screen.dart';
import 'package:comfort_crash/services/background_service.dart';
import 'package:comfort_crash/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize background service
  await BackgroundService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ComfortDataProvider()),
      ],
      child: MaterialApp(
        title: 'ComfortCrash',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const SplashScreen(),
      ),
    );
  }
}
