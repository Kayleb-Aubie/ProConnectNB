import 'package:flutter/material.dart';
import '../models/rappel.dart';
import '../services/api.dart';

class RappelProvider with ChangeNotifier {
  final List<Rappel> _rappels = [];
  final Api api = Api();

  List<Rappel> get rappels => List.unmodifiable(_rappels);

  List<Rappel> get rappelsActifs => _rappels.where((r) => r.actif).toList();

  List<Rappel> get rappelsDuJour {
    final today = DateTime.now();

    return _rappels.where((r) {
      return r.actif &&
          r.dateHeure.year == today.year &&
          r.dateHeure.month == today.month &&
          r.dateHeure.day == today.day;
    }).toList()..sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
  }

  Future<bool> addRappel(Rappel rappel) async {
    _rappels.add(rappel);
    _rappels.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
    notifyListeners();
    return true;
  }
  Future<void> fetchRappels() async {
  final data = await api.getRappels();

  _rappels.clear();
  _rappels.addAll(data.map((e) => Rappel.fromJson(e)));

  notifyListeners();
}

  Future<bool> updateRappel(Rappel rappel) async {
    final index = _rappels.indexWhere((r) => r.id == rappel.id);

    if (index == -1) return false;

    _rappels[index] = rappel;
    _rappels.sort((a, b) => a.dateHeure.compareTo(b.dateHeure));
    notifyListeners();

    return true;
  }

  Future<bool> deleteRappel(int id) async {
    final initialLength = _rappels.length;

    _rappels.removeWhere((r) => r.id == id);

    if (_rappels.length < initialLength) {
      notifyListeners();
      return true;
    }

    return false;
  }

  void toggleRappel(int id, bool value) {
    final index = _rappels.indexWhere((r) => r.id == id);

    if (index == -1) return;

    final old = _rappels[index];

    _rappels[index] = Rappel(
      id: old.id,
      dateHeure: old.dateHeure,
      type: old.type,
      actif: value,
      medicamentId: old.medicamentId,
      rendezVousMedicalId: old.rendezVousMedicalId,
    );

    notifyListeners();
  }

  void clear() {
    _rappels.clear();
    notifyListeners();
  }
}
