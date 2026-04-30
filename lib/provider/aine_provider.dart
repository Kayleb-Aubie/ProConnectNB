import 'package:flutter/material.dart';
import '../models/aine.dart';
import '../models/adresse.dart';
import '../services/aine_service.dart';
import 'auth_provider.dart';

class AineProvider with ChangeNotifier {
  final AineService _service = AineService();

  List<Aine> _aines = [];
  bool _isLoading = false;
  String _error = '';

  List<Aine> get aines => List.unmodifiable(_aines);
  bool get isLoading => _isLoading;
  String get error => _error;

  // =========================
  // FETCH (MODE TEST LOCAL)
  // =========================
  Future<void> fetchAines(AuthProvider auth) async {
    _setLoading(true);

    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return;
      _aines = await _service.getAines(auth.token!);
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(seconds: 1));
      if (_aines.isEmpty) {
        _aines = [
          Aine(
            id: 1,
            nom: "Aubie",
            prenom: "Jean-Guy",
            telephone: "506-546-0000",
            email: "jean.guy@nb.ca",
            dateNaissance: DateTime(1948, 10, 15),
            adresse: Adresse(
              rue: "789 Avenue des Pionniers",
              ville: "Bathurst",
              codePostal: "E2A 1V8",
            ),
            docteur: "Dr. Richard",
            numeroDocteur: "506-548-1234",
          ),
        ];
      }
      _error = '';
    } catch (e) {
      _error = "Erreur lors du chargement des aînés";
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // ADD (MODE TEST LOCAL)
  // =========================
  Future<bool> addAine(Map<String, dynamic> data, AuthProvider auth) async {
    _setLoading(true);

    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return false;
      final success = await _service.createAine(data, auth.token!);
      if (success) {
        await fetchAines(auth);
        return true;
      }
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(milliseconds: 800));

      // On convertit le Map reçu du formulaire en objet Aine pour l'affichage
      final nouvelAine = Aine(
        id: DateTime.now().millisecondsSinceEpoch,
        nom: data['nom'] ?? '',
        prenom: data['prenom'] ?? '',
        telephone: data['telephone'] ?? '',
        email: data['email'] ?? '',
        dateNaissance: data['dateNaissance'] != null
            ? DateTime.parse(data['dateNaissance'])
            : DateTime.now(),
        adresse: data['adresse'] != null
            ? Adresse.fromJson(data['adresse'])
            : null,
        docteur: data['docteur'] ?? '',
        numeroDocteur: data['numeroTelephoneDocteur'] ?? '',
      );

      _aines.insert(0, nouvelAine);
      return true;
    } catch (e) {
      _error = "Erreur lors de la création";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // =========================
  // DELETE (MODE TEST LOCAL)
  // =========================
  Future<bool> deleteAine(int id, AuthProvider auth) async {
    _setLoading(true);
    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return false;
      final success = await _api.delete("/api/Aine/$id", auth.token!);
      if (success) {
        _aines.removeWhere((a) => a.id == id);
        notifyListeners();
        return true;
      }
      return false;
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(const Duration(milliseconds: 500));
      _aines.removeWhere((a) => a.id == id);
      _error = '';
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
  // UPDATE (MODE TEST LOCAL)
  // =========================
  Future<bool> updateAine(
    int id,
    Map<String, dynamic> data,
    AuthProvider auth,
  ) async {
    _setLoading(true); // Active l'indicateur de chargement

    try {
      // --- BRANCHEMENT BACKEND PLUS TARD ---
      /*
      if (auth.token == null) return false;
      
      // On appelle le service API
      final success = await _service.updateAine(id, data, auth.token!);
      
      if (success) {
        // Option 1 : Recharger toute la liste depuis le serveur
        // await fetchAines(auth);
        
        // Option 2 : Mettre à jour l'objet localement pour économiser de la bande passante
        int index = _aines.indexWhere((a) => a.id == id);
        if (index != -1) {
          _aines[index] = Aine.fromJson({...data, 'id': id});
        }
      }
      return success;
      */

      // --- SIMULATION LOCAL POUR TEST ---
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Petit délai pour le réalisme

      int index = _aines.indexWhere((a) => a.id == id);
      if (index != -1) {
        // On remplace l'ancien aîné par le nouveau (avec les données du formulaire)
        _aines[index] = Aine.fromJson({...data, 'id': id});
        _error = '';
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = "Erreur lors de la mise à jour";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false); // Désactive l'indicateur de chargement
    }
  }

  // =========================
  // HELPERS
  // =========================
  void clearError() {
    _error = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
