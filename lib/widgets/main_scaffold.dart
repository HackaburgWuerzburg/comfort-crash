import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/comfort_radar_screen.dart';
import '../screens/pond_screen.dart';
import '../screens/fear_thermometer_screen.dart';
import '../screens/excuse_slayer_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _pages = [
    HomeScreen(),
    ComfortRadarScreen(),
    PondScreen(),
    FearThermometerScreen(),
    ExcuseSlayerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: FloatingActionButton(
          onPressed: () => setState(() => _currentIndex = 2),
          child: const Icon(Icons.water_drop),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(Icons.home, 0),
            _buildNavIcon(Icons.radar, 1),

            // Pond icon in the bar
            IconButton(
              icon: Icon(
                Icons.water_drop,
                color: _currentIndex == 2 ? Colors.redAccent : Colors.grey,
              ),
              onPressed: () => setState(() => _currentIndex = 2),
            ),

            _buildNavIcon(Icons.thermostat, 3),
            _buildNavIcon(Icons.question_mark, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int idx) {
    return IconButton(
      icon: Icon(icon, color: _currentIndex == idx ? Colors.redAccent : Colors.grey),
      onPressed: () => setState(() => _currentIndex = idx),
    );
  }
}
