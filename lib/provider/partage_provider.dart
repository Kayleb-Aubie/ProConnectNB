import 'package:flutter/material.dart';
import '../../services/api.dart';
import '../../models/partage_suivi.dart';
import 'auth_provider.dart';

class PartageProvider extends ChangeNotifier {
  final Api _api = Api();

  bool _isLoading = false;
  String _error = '';
  final List<PartageSuivi> _partages = [];

  bool get isLoading => _isLoading;
  String get error => _error;
  List<PartageSuivi> get partages => List.unmodifiable(_partages);

  // ======================================================
  // L'AÎNÉ AJOUTE UN PROCHE
  // ======================================================
  Future<bool> aineAjouteProche({
    required int aineId,
    required int procheId,
    required String relation,
    required AuthProvider auth,
  }) async {
    _setLoading(true);
    _error = '';

    try {
      // Un aîné donne généralement une autorisation complète à son proche
      final partage = PartageSuivi(
        id: 0,
        autorisation: Autorisation.complete,
        relation: relation,
        aineId: aineId,
        procheAidantId: procheId,
      );

      // --- LOGIQUE API (Décommenter quand l'API est prête) ---
      /*
      if (auth.token == null) {
        _error = "Session expirée";
        return false;
      }
      final result = await _api.upsertPartage(partage, auth.token!);
      if (result == null) {
         _error = "Erreur serveur lors du partage";
         return false;
      }
      _partages.add(result);
      */

      // --- SIMULATION POUR TESTS ---
      await Future.delayed(const Duration(milliseconds: 800));
      _partages.add(
        partage.copyWith(id: DateTime.now().millisecondsSinceEpoch),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _error = "Erreur : $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ======================================================
  // LE PROCHE INVITE UN AÎNÉ
  // ======================================================
  Future<bool> procheInviteAine({
    required int aineId,
    required int procheAidantId,
    required String relation,
    required AuthProvider auth,
  }) async {
    _setLoading(true);
    _error = '';

    try {
      // Un proche qui s'abonne demande souvent une autorisation d'écriture/lecture
      final partage = PartageSuivi(
        id: 0,
        autorisation: Autorisation.ecriture,
        relation: relation,
        aineId: aineId,
        procheAidantId: procheAidantId,
      );

      // --- LOGIQUE API (Décommenter quand l'API est prête) ---
      /*
      if (auth.token == null) return false;
      final result = await _api.upsertPartage(partage, auth.token!);
      if (result == null) return false;
      _partages.add(result);
      */

      // --- SIMULATION POUR TESTS ---
      await Future.delayed(const Duration(milliseconds: 800));
      _partages.add(
        partage.copyWith(id: DateTime.now().millisecondsSinceEpoch),
      );

      notifyListeners();
      return true;
    } catch (e) {
      _error = "Erreur : $e";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ======================================================
  // RÉCUPÉRATION DES PARTAGES
  // ======================================================
  Future<void> fetchPartages(AuthProvider auth) async {
    _setLoading(true);
    try {
      // Simulation de récupération API
      // final data = await _api.getPartages(auth.token!);
      // _partages.clear();
      // _partages.addAll(data);
    } catch (e) {
      _error = "Impossible de charger les partages";
    } finally {
      _setLoading(false);
    }
  }

  // ======================================================
  // HELPERS DE FILTRAGE (Pour la visibilité bidirectionnelle)
  // ======================================================

  /// Retourne les partages liés à un aîné spécifique (utilisé par l'aîné pour voir ses proches)
  List<PartageSuivi> getPartagesParAine(int aineId) {
    return _partages.where((p) => p.aineId == aineId).toList();
  }

  /// Retourne les partages liés à un proche spécifique (utilisé par le proche pour voir ses aînés)
  List<PartageSuivi> getPartagesParProche(int procheId) {
    return _partages.where((p) => p.procheAidantId == procheId).toList();
  }

  // ======================================================
  // GESTION D'ÉTAT
  // ======================================================

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
