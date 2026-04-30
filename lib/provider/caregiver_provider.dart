import 'package:flutter/material.dart';
import '../models/caregiver.dart';
import '../models/adresse.dart';
import '../services/api.dart';
import 'auth_provider.dart';

class CaregiverProvider with ChangeNotifier {
  final Api _api = Api();

  List<Caregiver> _caregivers = [];
  bool _isLoading = false;
  String _error = '';

  List<Caregiver> get caregivers => List.unmodifiable(_caregivers);
  bool get isLoading => _isLoading;
  String get error => _error;

  // =========================
  // FETCH (MODE TEST LOCAL)
  // =========================
  Future<void> fetchCaregivers(AuthProvider auth) async {
    _setLoading(true);

    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return;
      final List<dynamic> data = await _api.getCaregivers(auth.token!);
      _caregivers = data.map((json) => Caregiver.fromJson(json)).toList();
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(seconds: 1));
      if (_caregivers.isEmpty) {
        _caregivers = [
          Caregiver(
            id: 1,
            nom: "Aubie",
            prenom: "Kayleb",
            telephone: "506-123-4567",
            email: "kayleb@test.com",
            adresse: Adresse(
              rue: "123 Rue Main",
              ville: "Bathurst",
              codePostal: "E2A 1A1",
            ),
          ),
        ];
      }
      _error = '';
    } catch (e) {
      _error = "Erreur lors du chargement des proches";
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // ADD (MODE TEST LOCAL)
  // =========================
  Future<bool> addCaregiver({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    Adresse? adresse,
    required AuthProvider auth,
  }) async {
    _setLoading(true);

    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return false;
      final Map<String, dynamic> body = {
        "nom": nom,
        "prenom": prenom,
        "telephone": telephone,
        "email": email,
        "adresse": adresse?.toJson(),
      };
      final success = await _api.post("/api/ProcheAidant", body, auth.token!);
      if (success) {
        await fetchCaregivers(auth);
        return true;
      }
      return false;
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(milliseconds: 800));
      final nouveauCaregiver = Caregiver(
        id: DateTime.now().millisecondsSinceEpoch,
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        email: email,
        adresse: adresse,
      );
      _caregivers.insert(0, nouveauCaregiver);
      return true;
    } catch (e) {
      _error = "Erreur lors de la création";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // UPDATE (MODE TEST LOCAL)
  // =========================
  Future<bool> updateCaregiver(int id, Map<String, dynamic> data, AuthProvider auth) async {
    _setLoading(true);

    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return false;
      final success = await _api.put("/api/ProcheAidant/$id", data, auth.token!);
      if (success) {
        await fetchCaregivers(auth);
        return true;
      }
      return false;
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(milliseconds: 500));
      int index = _caregivers.indexWhere((c) => c.id == id);
      if (index != -1) {
        _caregivers[index] = Caregiver.fromJson({...data, 'id': id});
        _error = '';
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = "Erreur lors de la modification";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // DELETE (MODE TEST LOCAL)
  // =========================
  Future<bool> deleteCaregiver(int id, AuthProvider auth) async {
    _setLoading(true);

    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return false;
      final success = await _api.delete("/api/ProcheAidant/$id", auth.token!);
      if (success) {
        _caregivers.removeWhere((c) => c.id == id);
        notifyListeners();
        return true;
      }
      return false;
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(milliseconds: 500));
      _caregivers.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = "Erreur lors de la suppression";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // HELPERS
  // =========================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}