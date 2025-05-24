// lib/services/user_provider.dart

import 'package:flutter/foundation.dart';

/// Holds user‐specific state (e.g. coin balance).
class UserProvider extends ChangeNotifier {
  int _coins = 0;

  int get coins => _coins;

  /// Award one coin.
  void addCoin() {
    _coins++;
    notifyListeners();
  }

  /// Spend one coin if available.
  bool useCoin() {
    if (_coins > 0) {
      _coins--;
      notifyListeners();
      return true;
    }
    return false;
  }
}
