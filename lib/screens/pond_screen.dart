import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PondScreen extends StatefulWidget {
  const PondScreen({Key? key}) : super(key: key);

  @override
  State<PondScreen> createState() => _PondScreenState();
}

class _PondScreenState extends State<PondScreen> {
  late RiveAnimationController _coinController;
  late RiveAnimationController _rippleController;
  int _coinBalance = 5;

  @override
  void initState() {
    super.initState();
    _coinController = OneShotAnimation('Toss', autoplay: false);
    _rippleController = OneShotAnimation('Splash', autoplay: false);
  }

  void _throwCoin() {
    if (_coinBalance <= 0) return;
    setState(() => _coinBalance--);
    _coinController.isActive = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      _rippleController.isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background
        Positioned.fill(child: Container(color: Colors.black87)),

        // Ripple animation
        RiveAnimation.asset(
          'assets/animations/pond_ripple.riv',
          controllers: [_rippleController],
          fit: BoxFit.cover,
        ),

        // Coin toss animation
        RiveAnimation.asset(
          'assets/animations/coin_toss.riv',
          controllers: [_coinController],
        ),

        // Overlay: coin count + button
        Positioned(
          bottom: 80,
          child: Column(
            children: [
              Text(
                'Coins: $_coinBalance',
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.monetization_on),
                label: const Text('Throw Coin'),
                onPressed: _throwCoin,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
