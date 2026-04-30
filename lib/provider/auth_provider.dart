import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api.dart';

class AuthProvider with ChangeNotifier {
  final Api _api = Api();

  bool _isAuthenticated = false;
  bool _isLoading = false;

  String? _token;
  String? _firstName;
  String? _role;
  int? _userId;
  String? _errorMessage;
  String? _profilePicture;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  String? get token => _token;
  String? get firstName => _firstName;
  String? get role => _role;
  int? get currentUserLocalId => _userId;
  String? get errorMessage => _errorMessage;
  String? get profilePicture => _profilePicture;

  bool get isAine => _role == "AINE";
  bool get isAidant => _role == "AIDANT";

  Future<bool> login(String email, String password) async {
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _api.login(email, password);

      if (result == null || result["success"] == false) {
        _errorMessage = result?["message"] ?? "Email ou mot de passe incorrect";
        _isAuthenticated = false;
        return false;
      }

      _token = result["token"];
      _firstName = result["firstName"] ?? email.split('@')[0];
      _role = result["role"];
      _userId = result["userId"];
      _profilePicture = result["profilePicture"];

      if (_token == null || _role == null) {
        _errorMessage = "Réponse serveur invalide";
        _isAuthenticated = false;
        return false;
      }

      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", _token!);
      await prefs.setString("firstName", _firstName ?? "");
      await prefs.setString("role", _role!);
      if (_userId != null) await prefs.setInt("userId", _userId!);
      await prefs.setString("profilePicture", _profilePicture ?? "");
      await prefs.setBool("isAuth", true);

      return true;
    } catch (e) {
      _errorMessage = "Erreur de connexion";
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    if (_isLoading) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(seconds: 1));

      // Au lieu d'appeler _api.register (qui n'existe pas ou est commenté)
      // On simule une réponse positive immédiate
      final result = {
        "success": true,
        "email": email,
        "firstName": firstName,
        "role": role,
      };

      /* // BRANCHEMENT BACKEND PLUS TARD :
      final result = await _api.post("/api/auth/register", {
        "prenom": firstName,
        "nom": lastName,
        "email": email,
        "password": password,
        "telephone": phone,
        "role": role,
      }, ""); 
      */

      if (result["success"] == false) {
        _errorMessage = "Erreur création compte";
        return false;
      }

      _isLoading = false;
      notifyListeners();

      return await login(email, password);
    } catch (e) {
      _errorMessage = "Erreur lors de l'inscription";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final role = prefs.getString("role");
    final firstName = prefs.getString("firstName");
    final profilePicture = prefs.getString("profilePicture");
    final isAuth = prefs.getBool("isAuth") ?? false;
    final userId = prefs.getInt("userId");

    if (!isAuth ||
        token == null ||
        token.isEmpty ||
        role == null ||
        role.isEmpty) {
      return false;
    }

    _token = token;
    _role = role;
    _userId = userId;
    _firstName = firstName;
    _profilePicture = profilePicture;
    _isAuthenticated = true;

    notifyListeners();
    return true;
  }

  Future<void> updateProfilePicture(String newUrl) async {
    _profilePicture = newUrl;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profilePicture", newUrl);

    notifyListeners();
  }

  Future<void> updateUserInfo({String? newName}) async {
    if (newName == null || newName.trim().isEmpty) return;

    _firstName = newName.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("firstName", _firstName!);

    notifyListeners();
  }

  Future<void> clearProfilePicture() async {
    _profilePicture = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("profilePicture");

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _isAuthenticated = false;
    _isLoading = false;
    _token = null;
    _role = null;
    _userId = null;
    _firstName = null;
    _errorMessage = null;
    _profilePicture = null;

    notifyListeners();
  }

  void reset() {
    _isAuthenticated = false;
    _isLoading = false;
    _token = null;
    _role = null;
    _firstName = null;
    _errorMessage = null;
    _profilePicture = null;

    notifyListeners();
  }
}
