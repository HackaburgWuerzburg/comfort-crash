import 'package:flutter/material.dart';
import 'package:comfort_crash/services/gemini_service.dart';
import 'package:comfort_crash/models/chat_message.dart';

class ComfortDataProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  
  // Comfort Zone Radar
  List<double> _comfortLevels = [0.8, 0.6, 0.4, 0.7, 0.5]; // Sample data
  List<String> _comfortPatterns = [];
  List<String> _discomfortGoals = [];
  bool _isAnalyzing = false;
  
  // Crash Button
  String _currentChallenge = '';
  bool _isLoading = false;
  
  // Fear Thermometer
  String _currentFear = '';
  int _fearIntensity = 0;
  String _fearTask = '';
  List<int> _fearHistory = [];
  bool _isAnalyzingFear = false;
  
  // Excuse Slayer
  final List<ChatMessage> _excuseConversation = [];
  bool _isAnalyzingExcuse = false;
  
  // Getters
  List<double> get comfortLevels => _comfortLevels;
  List<String> get comfortPatterns => _comfortPatterns;
  List<String> get discomfortGoals => _discomfortGoals;
  bool get isAnalyzing => _isAnalyzing;
  
  String get currentChallenge => _currentChallenge;
  bool get isLoading => _isLoading;
  
  String get currentFear => _currentFear;
  int get fearIntensity => _fearIntensity;
  String get fearTask => _fearTask;
  List<int> get fearHistory => _fearHistory;
  bool get isAnalyzingFear => _isAnalyzingFear;
  
  List<ChatMessage> get excuseConversation => _excuseConversation;
  bool get isAnalyzingExcuse => _isAnalyzingExcuse;
  
  // Methods
  Future<void> loadData() async {
    // In a real app, this would load data from local storage or a database
    // For now, we'll use sample data
    
    // Initialize with welcome message for Excuse Slayer
    if (_excuseConversation.isEmpty) {
      _excuseConversation.add(
        ChatMessage(
          text: 'I\'m your Excuse Slayer coach. Tell me your excuses, and I\'ll help you overcome them with some tough love!',
          isUser: false,
        ),
      );
    }
    
    notifyListeners();
  }
  
  // Comfort Zone Radar
  Future<void> analyzeComfortPatterns() async {
    if (_isAnalyzing) return;
    
    _isAnalyzing = true;
    notifyListeners();
    
    try {
      // In a real app, this would collect real user data
      final userData = {
        'app_usage': 'Social media: 2 hours daily, Productivity apps: 30 minutes',
        'locations': 'Home: 70%, Office: 20%, New places: 10%',
        'schedule': 'Regular routine, few new events',
      };
      
      final result = await _geminiService.analyzeComfortPatterns(userData);
      
      _comfortPatterns = result.patterns;
      _discomfortGoals = result.goals;
      
      // Update comfort levels based on analysis
      if (result.levels.isNotEmpty && result.levels.length == 5) {
        _comfortLevels = result.levels;
      }
    } catch (e) {
      debugPrint('Error analyzing comfort patterns: $e');
      // Use fallback data
      _comfortPatterns = [
        'You tend to stick to familiar social circles and avoid networking events.',
        'You rarely try new physical activities or challenges.',
        'You have a consistent daily routine with minimal variation.',
      ];
      
      _discomfortGoals = [
        'Attend one networking event this month',
        'Try a new physical activity weekly',
        'Change your routine by taking a different route to work',
      ];
    } finally {
      _isAnalyzing = false;
      notifyListeners();
    }
  }
  
  // Crash Button
  Future<void> generateCrashChallenge() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final challenge = await _geminiService.generateCrashChallenge();
      _currentChallenge = challenge;
    } catch (e) {
      debugPrint('Error generating crash challenge: $e');
      // Fallback challenges
      final fallbackChallenges = [
        'Talk to a stranger and ask them what book changed their life.',
        'Don\'t use your dominant hand for the next 30 minutes.',
        'Call someone you haven\'t spoken to in months.',
        'Try a food you\'ve always avoided.',
      ];
      
      _currentChallenge = fallbackChallenges[DateTime.now().second % fallbackChallenges.length];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void completeChallenge() {
    _currentChallenge = '';
    notifyListeners();
  }
  
  // Fear Thermometer
  Future<void> analyzeFear(String fear) async {
    if (_isAnalyzingFear) return;
    
    _isAnalyzingFear = true;
    _currentFear = fear;
    notifyListeners();
    
    try {
      final result = await _geminiService.analyzeFear(fear);
      
      _fearIntensity = result.intensity;
      _fearTask = result.task;
      
      // Add to history if it's a new fear
      if (_fearHistory.isEmpty) {
        _fearHistory = [result.intensity, result.intensity - 1, result.intensity - 2];
      } else {
        _fearHistory.add(result.intensity);
      }
    } catch (e) {
      debugPrint('Error analyzing fear: $e');
      // Fallback data
      _fearIntensity = 7;
      _fearTask = 'Practice speaking in front of a mirror for 5 minutes daily.';
      
      if (_fearHistory.isEmpty) {
        _fearHistory = [7, 6, 5];
      } else {
        _fearHistory.add(7);
      }
    } finally {
      _isAnalyzingFear = false;
      notifyListeners();
    }
  }
  
  void completeFearTask() {
    if (_fearHistory.isNotEmpty && _fearIntensity > 1) {
      _fearIntensity--;
      _fearHistory.add(_fearIntensity);
      notifyListeners();
    }
  }
  
  // Excuse Slayer
  Future<void> analyzeExcuse(String excuse) async {
    if (_isAnalyzingExcuse) return;
    
    _isAnalyzingExcuse = true;
    
    // Add user message
    _excuseConversation.add(ChatMessage(text: excuse, isUser: true));
    notifyListeners();
    
    try {
      final response = await _geminiService.analyzeExcuse(excuse);
      
      // Add AI response
      _excuseConversation.add(ChatMessage(text: response, isUser: false));
    } catch (e) {
      debugPrint('Error analyzing excuse: $e');
      // Fallback response
      _excuseConversation.add(
        ChatMessage(
          text: 'That sounds like an excuse to me! Remember, growth happens outside your comfort zone. What small step can you take right now?',
          isUser: false,
        ),
      );
    } finally {
      _isAnalyzingExcuse = false;
      notifyListeners();
    }
  }
}
