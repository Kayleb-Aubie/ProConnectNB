import 'package:flutter/material.dart';
import '../models/activity.dart';

class DailyActivity {
  final DateTime date;
  int steps;
  int stepGoal;
  int activeMinutes;
  int caloriesBurned;

  DailyActivity({
    required this.date,
    required this.steps,
    required this.stepGoal,
    required this.activeMinutes,
    required this.caloriesBurned,
  });

  double get progressRatio {
    if (stepGoal == 0) return 0;
    return (steps / stepGoal).clamp(0.0, 1.0);
  }
}

class ActivityProvider with ChangeNotifier {
  late List<DailyActivity> _weeklyHistory;

  bool _isLoading = true;
  String _errorMessage = "";

  final List<ActiviteIA> _activitesIA = [];
  String _currentCity = "Bathurst";

  ActivityProvider() {
    _initializeData();
  }

  List<DailyActivity> get weeklyHistory => List.unmodifiable(_weeklyHistory);
  DailyActivity get todayActivity => _weeklyHistory.last;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  List<ActiviteIA> get activitesIA => List.unmodifiable(_activitesIA);
  String get currentCity => _currentCity;

  Future<void> _initializeData() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final DateTime now = DateTime.now();

    _weeklyHistory = List.generate(7, (index) {
      final DateTime day = now.subtract(Duration(days: 6 - index));
      final bool isToday = index == 6;

      return DailyActivity(
        date: day,
        steps: isToday ? 3450 : 6000 + (index * 500) % 3000,
        stepGoal: 8000,
        activeMinutes: isToday ? 25 : 45 + (index * 10) % 30,
        caloriesBurned: isToday ? 150 : 300 + (index * 50) % 200,
      );
    });

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addSteps(int newSteps) async {
    if (_isLoading) return;

    _weeklyHistory.last.steps += newSteps;

    if (_weeklyHistory.last.steps > _weeklyHistory.last.stepGoal) {
      _weeklyHistory.last.steps = _weeklyHistory.last.stepGoal;
    }

    notifyListeners();
  }

  Future<void> fetchAIActivities({String region = "Bathurst"}) async {
    _isLoading = true;
    _errorMessage = "";
    _currentCity = region;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _activitesIA.clear();

      _activitesIA.addAll([
        ActiviteIA(
          id: 1,
          titre: "Marche santé",
          description: "Activité légère recommandée pour rester actif.",
          dateHeure: DateTime.now().add(const Duration(hours: 2)),
          lieu: "Centre-ville de $region",
          categorie: "Santé",
          scorePertinence: 0.95,
          region: region,
        ),
        ActiviteIA(
          id: 2,
          titre: "Atelier communautaire",
          description: "Rencontre sociale et activité de groupe.",
          dateHeure: DateTime.now().add(const Duration(days: 1, hours: 3)),
          lieu: "Centre communautaire de $region",
          categorie: "Social",
          scorePertinence: 0.88,
          region: region,
        ),
        ActiviteIA(
          id: 3,
          titre: "Exercice doux",
          description: "Séance adaptée pour les aînés.",
          dateHeure: DateTime.now().add(const Duration(days: 2)),
          lieu: "Salle municipale de $region",
          categorie: "Sport",
          scorePertinence: 0.82,
          region: region,
        ),
      ]);
    } catch (e) {
      _errorMessage = "Erreur lors du chargement des activités";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
