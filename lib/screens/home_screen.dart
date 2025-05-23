import 'package:flutter/material.dart';
import 'package:comfort_crash/theme/app_theme.dart';
import 'package:comfort_crash/widgets/crash_button.dart';
import 'package:comfort_crash/screens/comfort_radar_screen.dart';
import 'package:comfort_crash/screens/fear_thermometer_screen.dart';
import 'package:comfort_crash/screens/excuse_slayer_screen.dart';
import 'package:comfort_crash/providers/user_provider.dart';
import 'package:comfort_crash/providers/comfort_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:comfort_crash/services/background_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeData();
    BackgroundService.startComfortAlarmService();
  }
  
  Future<void> _initializeData() async {
    final comfortDataProvider = Provider.of<ComfortDataProvider>(context, listen: false);
    await comfortDataProvider.loadData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final comfortDataProvider = Provider.of<ComfortDataProvider>(context);
    
    final List<Widget> _pages = [
      // Home page with Crash Button
      _buildHomePage(comfortDataProvider),
      // Comfort Radar
      const ComfortRadarScreen(),
      // Fear Thermometer
      const FearThermometerScreen(),
      // Excuse Slayer
      const ExcuseSlayerScreen(),
    ];
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('ComfortCrash'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                userProvider.isLoggedIn
                    ? userProvider.user!.displayName![0].toUpperCase()
                    : 'G',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () {
              // TODO: Open profile screen
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.darkBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar),
              label: 'Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thermostat),
              label: 'Fear',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: 'Excuses',
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHomePage(ComfortDataProvider comfortDataProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ready to crash your comfort zone?',
            style: AppTheme.subheadingStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          CrashButton(
            onPressed: () async {
              await comfortDataProvider.generateCrashChallenge();
            },
            isLoading: comfortDataProvider.isLoading,
            challenge: comfortDataProvider.currentChallenge,
          ),
          const SizedBox(height: 40),
          if (comfortDataProvider.currentChallenge.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ElevatedButton(
                onPressed: () {
                  comfortDataProvider.completeChallenge();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Challenge completed! +50 XP'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Mark as Complete'),
              ),
            ),
        ],
      ),
    );
  }
}
