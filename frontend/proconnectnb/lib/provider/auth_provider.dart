import 'package:flutter/material.dart';
import '../services/api.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    final api = Api();

    bool success = await api.loginMock(email, password);

    _isAuthenticated = success;

    notifyListeners(); // met à jour toute l’app

    return success;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

 