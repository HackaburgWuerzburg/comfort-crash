// lib/services/comfort_data_provider.dart

import 'package:flutter/foundation.dart';

/// Holds shared data for your comfort/radar/fear/excuse screens.
class ComfortDataProvider extends ChangeNotifier {
  Map<String, dynamic> _results = {};
  Map<String, dynamic> get results => _results;

  void saveResults(Map<String, dynamic> newResults) {
    _results = newResults;
    notifyListeners();
  }

// Add more shared methods/state here as needed…
}
