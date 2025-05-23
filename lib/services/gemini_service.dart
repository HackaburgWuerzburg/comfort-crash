import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // In a real app, this would be stored securely and not hardcoded
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';
  late final GenerativeModel _model;
  
  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }
  
  // Comfort Zone Radar
  Future<ComfortAnalysisResult> analyzeComfortPatterns(Map<String, String> userData) async {
    try {
      final prompt = '''
Based on this user's behavior:
- App usage: ${userData['app_usage']}
- Locations: ${userData['locations']}
- Schedule: ${userData['schedule']}

Identify patterns of psychological comfort zones and suggest discomfort tasks.
Format your response as follows:
PATTERNS:
1. [First pattern]
2. [Second pattern]
3. [Third pattern]

GOALS:
1. [First goal]
2. [Second goal]
3. [Third goal]

LEVELS:
[Five comma-separated decimal values between 0 and 1 representing comfort levels in Social, Career, Learning, Physical, Creative areas]
''';

      // If API key is not set, return mock data
      if (_apiKey == 'YOUR_GEMINI_API_KEY') {
        return _getMockComfortAnalysis();
      }

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final responseText = response.text ?? '';
      
      return _parseComfortAnalysisResponse(responseText);
    } catch (e) {
      debugPrint('Error in analyzeComfortPatterns: $e');
      return _getMockComfortAnalysis();
    }
  }
  
  ComfortAnalysisResult _parseComfortAnalysisResponse(String response) {
    final patterns = <String>[];
    final goals = <String>[];
    final levels = <double>[];
    
    try {
      // Extract patterns
      final patternsMatch = RegExp(r'PATTERNS:(.*?)(?=GOALS:|$)', dotAll: true).firstMatch(response);
      if (patternsMatch != null) {
        final patternsText = patternsMatch.group(1) ?? '';
        final patternLines = patternsText.split('\n')
            .where((line) => line.trim().isNotEmpty && RegExp(r'^\d+\.').hasMatch(line.trim()))
            .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
            .toList();
        patterns.addAll(patternLines);
      }
      
      // Extract goals
      final goalsMatch = RegExp(r'GOALS:(.*?)(?=LEVELS:|$)', dotAll: true).firstMatch(response);
      if (goalsMatch != null) {
        final goalsText = goalsMatch.group(1) ?? '';
        final goalLines = goalsText.split('\n')
            .where((line) => line.trim().isNotEmpty && RegExp(r'^\d+\.').hasMatch(line.trim()))
            .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
            .toList();
        goals.addAll(goalLines);
      }
      
      // Extract levels
      final levelsMatch = RegExp(r'LEVELS:\s*\[(.*?)\]').firstMatch(response);
      if (levelsMatch != null) {
        final levelsText = levelsMatch.group(1) ?? '';
        final levelValues = levelsText.split(',')
            .map((s) => double.tryParse(s.trim()) ?? 0.5)
            .toList();
        levels.addAll(levelValues);
      }
    } catch (e) {
      debugPrint('Error parsing comfort analysis: $e');
    }
    
    // Ensure we have at least some data
    if (patterns.isEmpty) {
      patterns.addAll([
        'You tend to stick to familiar social circles and avoid networking events.',
        'You rarely try new physical activities or challenges.',
        'You have a consistent daily routine with minimal variation.',
      ]);
    }
    
    if (goals.isEmpty) {
      goals.addAll([
        'Attend one networking event this month',
        'Try a new physical activity weekly',
        'Change your routine by taking a different route to work',
      ]);
    }
    
    if (levels.isEmpty || levels.length != 5) {
      levels.clear();
      levels.addAll([0.8, 0.6, 0.4, 0.7, 0.5]);
    }
    
    return ComfortAnalysisResult(
      patterns: patterns,
      goals: goals,
      levels: levels,
    );
  }
  
  ComfortAnalysisResult _getMockComfortAnalysis() {
    return ComfortAnalysisResult(
      patterns: [
        'You tend to stick to familiar social circles and avoid networking events.',
        'You rarely try new physical activities or challenges.',
        'You have a consistent daily routine with minimal variation.',
      ],
      goals: [
        'Attend one networking event this month',
        'Try a new physical activity weekly',
        'Change your routine by taking a different route to work',
      ],
      levels: [0.8, 0.6, 0.4, 0.7, 0.5],
    );
  }
  
  // Crash Button
  Future<String> generateCrashChallenge() async {
    try {
      const prompt = '''
Generate a short, bold, time-bound discomfort challenge that pushes someone out of their comfort zone.
The challenge should be specific, actionable, and completable within 30 minutes to 24 hours.
Format your response as a single paragraph with no additional text.
''';

      // If API key is not set, return mock data
      if (_apiKey == 'YOUR_GEMINI_API_KEY') {
        return _getMockCrashChallenge();
      }

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final challenge = response.text?.trim() ?? '';
      
      return challenge.isNotEmpty ? challenge : _getMockCrashChallenge();
    } catch (e) {
      debugPrint('Error in generateCrashChallenge: $e');
      return _getMockCrashChallenge();
    }
  }
  
  String _getMockCrashChallenge() {
    final challenges = [
      'Talk to a stranger and ask them what book changed their life.',
      'Don\'t use your dominant hand for the next 30 minutes.',
      'Call someone you haven\'t spoken to in months.',
      'Try a food you\'ve always avoided.',
      'Record a 1-minute video of yourself dancing and share it with a friend.',
    ];
    
    return challenges[DateTime.now().second % challenges.length];
  }
  
  // Fear Thermometer
  Future<FearAnalysisResult> analyzeFear(String fear) async {
    try {
      final prompt = '''
This user is afraid of: $fear
Rate the intensity from 1-10 and suggest a progressive exposure task that slightly pushes their boundary.
Format your response as follows:
INTENSITY: [number 1-10]
TASK: [suggested task]
''';

      // If API key is not set, return mock data
      if (_apiKey == 'YOUR_GEMINI_API_KEY') {
        return _getMockFearAnalysis(fear);
      }

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final responseText = response.text ?? '';
      
      return _parseFearAnalysisResponse(responseText, fear);
    } catch (e) {
      debugPrint('Error in analyzeFear: $e');
      return _getMockFearAnalysis(fear);
    }
  }
  
  FearAnalysisResult _parseFearAnalysisResponse(String response, String fear) {
    int intensity = 5;
    String task = '';
    
    try {
      // Extract intensity
      final intensityMatch = RegExp(r'INTENSITY:\s*(\d+)').firstMatch(response);
      if (intensityMatch != null) {
        intensity = int.tryParse(intensityMatch.group(1) ?? '5') ?? 5;
        // Ensure it's between 1-10
        intensity = intensity.clamp(1, 10);
      }
      
      // Extract task
      final taskMatch = RegExp(r'TASK:\s*(.+)(?:\n|$)').firstMatch(response);
      if (taskMatch != null) {
        task = taskMatch.group(1)?.trim() ?? '';
      }
    } catch (e) {
      debugPrint('Error parsing fear analysis: $e');
    }
    
    // Fallback if parsing failed
    if (task.isEmpty) {
      task = _getDefaultTaskForFear(fear, intensity);
    }
    
    return FearAnalysisResult(
      intensity: intensity,
      task: task,
    );
  }
  
  FearAnalysisResult _getMockFearAnalysis(String fear) {
    // Default intensities for common fears
    final Map<String, int> fearIntensities = {
      'public speaking': 7,
      'heights': 8,
      'spiders': 6,
      'failure': 7,
      'rejection': 6,
      'flying': 5,
    };
    
    // Get intensity based on the fear, or default to 5
    int intensity = 5;
    for (final entry in fearIntensities.entries) {
      if (fear.toLowerCase().contains(entry.key)) {
        intensity = entry.value;
        break;
      }
    }
    
    final task = _getDefaultTaskForFear(fear, intensity);
    
    return FearAnalysisResult(
      intensity: intensity,
      task: task,
    );
  }
  
  String _getDefaultTaskForFear(String fear, int intensity) {
    final lowerFear = fear.toLowerCase();
    
    if (lowerFear.contains('public speaking')) {
      return 'Record yourself speaking for 2 minutes on any topic and listen to it.';
    } else if (lowerFear.contains('height')) {
      return 'Look at pictures of high places for 5 minutes, practicing deep breathing.';
    } else if (lowerFear.contains('spider') || lowerFear.contains('insect')) {
      return 'Look at pictures of spiders for 2 minutes, gradually increasing the size of the images.';
    } else if (lowerFear.contains('fail')) {
      return 'Write down three small tasks where failure would be acceptable, and try one today.';
    } else if (lowerFear.contains('reject')) {
      return 'Ask someone for a small favor that they might refuse.';
    } else if (lowerFear.contains('fly')) {
      return 'Watch a 10-minute video of a smooth airplane flight.';
    } else {
      return 'Spend 5 minutes visualizing yourself calmly facing this fear, using deep breathing techniques.';
    }
  }
  
  // Excuse Slayer
  Future<String> analyzeExcuse(String excuse) async {
    try {
      final prompt = '''
The user just said: "$excuse"
Reply as a motivational, witty coach that exposes the excuse and pushes the user to act.
Use tough love, humor, and inspiration to motivate them.
Keep your response concise (2-3 sentences) and direct.
''';

      // If API key is not set, return mock data
      if (_apiKey == 'YOUR_GEMINI_API_KEY') {
        return _getMockExcuseResponse(excuse);
      }

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '';
      
      return responseText.isNotEmpty ? responseText : _getMockExcuseResponse(excuse);
    } catch (e) {
      debugPrint('Error in analyzeExcuse: $e');
      return _getMockExcuseResponse(excuse);
    }
  }
  
  String _getMockExcuseResponse(String excuse) {
    final lowerExcuse = excuse.toLowerCase();
    
    if (lowerExcuse.contains('not ready')) {
      return "You'll never be 'ready' if you keep waiting for the perfect moment. The only way to get ready is to start now, even if it's messy.";
    } else if (lowerExcuse.contains('too busy') || lowerExcuse.contains('no time')) {
      return "Everyone has the same 24 hours. What you're really saying is 'it's not a priority.' Is Netflix more important than your dreams?";
    } else if (lowerExcuse.contains('too hard') || lowerExcuse.contains('too difficult')) {
      return "Of course it's hard! If it were easy, everyone would do it. The difficulty is what makes it valuable.";
    } else if (lowerExcuse.contains('tomorrow') || lowerExcuse.contains('later')) {
      return "Ah, the magical land of 'tomorrow' where all your productivity supposedly lives. Spoiler alert: tomorrow's you will have the same excuses.";
    } else if (lowerExcuse.contains('tired') || lowerExcuse.contains('exhausted')) {
      return "Tired is temporary, regret is permanent. Give me 5 minutes of effort, and I bet you'll find the energy you 'didn't have.'";
    } else {
      return "That sounds like an excuse wrapped in a justification, served with a side of procrastination. What small step can you take RIGHT NOW?";
    }
  }
}

class ComfortAnalysisResult {
  final List<String> patterns;
  final List<String> goals;
  final List<double> levels;

  ComfortAnalysisResult({
    required this.patterns,
    required this.goals,
    required this.levels,
  });
}

class FearAnalysisResult {
  final int intensity;
  final String task;

  FearAnalysisResult({
    required this.intensity,
    required this.task,
  });
}
