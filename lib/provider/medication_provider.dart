import 'package:flutter/material.dart';

class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;

  bool isTaken;
  bool isActive;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.isTaken = false,
    this.isActive = false,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? time,
    bool? isTaken,
    bool? isActive,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      isTaken: isTaken ?? this.isTaken,
      isActive: isActive ?? this.isActive,
    );
  }
}

class MedicationProvider with ChangeNotifier {
  final List<Medication> _medications = [
    Medication(
      id: '1',
      name: 'Amoxicilline',
      dosage: '500mg',
      time: '08:00',
      isTaken: true,
      isActive: true,
    ),
    Medication(
      id: '2',
      name: 'Lisinopril',
      dosage: '10mg',
      time: '20:00',
      isTaken: false,
      isActive: false,
    ),
  ];

  List<Medication> get medications => List.unmodifiable(_medications);

  List<Medication> get activeMedications =>
      _medications.where((m) => m.isActive).toList();

  double get adherenceRate {
    if (_medications.isEmpty) return 0.0;
    final takenCount = _medications.where((m) => m.isTaken).length;
    return takenCount / _medications.length;
  }

  void toggleTaken(String id) {
    final index = _medications.indexWhere((m) => m.id == id);

    if (index != -1) {
      _medications[index].isTaken = !_medications[index].isTaken;
      notifyListeners();
    }
  }

  void toggleActive(String id, bool value) {
    final index = _medications.indexWhere((m) => m.id == id);
    if (index != -1) {
      _medications[index].isActive = value;
      notifyListeners();
    }
  }

  void renewMedication(String id) {
    final index = _medications.indexWhere((m) => m.id == id);

    if (index != -1) {
      _medications[index].isTaken = false;
      notifyListeners();
    }
  }

  Future<bool> addMedication(
    String name,
    String dosage,
    String time, {
    bool isActive = false,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final newMed = Medication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        dosage: dosage,
        time: time,
        isTaken: false,
        isActive: isActive,
      );

      _medications.add(newMed);
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateMedication(
    String id,
    String name,
    String dosage,
    String time, {
    bool? isActive,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _medications.indexWhere((m) => m.id == id);

      if (index == -1) return false;

      final current = _medications[index];

      _medications[index] = current.copyWith(
        name: name,
        dosage: dosage,
        time: time,
        isActive: isActive ?? current.isActive,
      );

      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteMedication(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));

      final initialLength = _medications.length;
      _medications.removeWhere((m) => m.id == id);

      if (_medications.length < initialLength) {
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
