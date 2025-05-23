import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class BackgroundService {
  static Future<void> initialize() async {
    debugPrint('Background service initialized in simplified mode');
  }
  
  static Future<void> startComfortAlarmService() async {
    debugPrint('Comfort alarm service started in simplified mode');
    // Simulate periodic checks with a one-time check
    _checkComfortZone();
  }
  
  static Future<void> _checkComfortZone() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDiscomfortTime = prefs.getInt('lastDiscomfortTime') ?? 0;
    
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeDifference = currentTime - lastDiscomfortTime;
    
    if (timeDifference > 30 * 60 * 1000) {
      _showComfortAlarmNotification();
    }
  }
  
  static Future<void> _showComfortAlarmNotification() async {
    // Get a random micro-task
    final microTasks = [
      'Call someone. Change task. Pitch your idea.',
      'Take a different route home today.',
      'Strike up a conversation with a stranger.',
      'Strike up a conversation with a stranger.',
      'Try a new food for lunch.',
      'Do 10 pushups right now.',
    ];
    
    final random = Random();
    final task = microTasks[random.nextInt(microTasks.length)];
    
    // Instead of showing a notification, we'll just print to console
    debugPrint('COMFORT ALARM: You\'re in a comfort coma!');
    debugPrint('TASK: $task');
    
    // In a real app, you would show a notification here
  }
}
