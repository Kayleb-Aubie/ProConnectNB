// ✅ PAS DANS UNE AUTRE CLASSE

class ActiviteIA {
  final int id;
  final String titre;
  final String description;
  final DateTime dateHeure;
  final String lieu;
  final String categorie;
  final double scorePertinence;
  final String region;

  ActiviteIA({
    required this.id,
    required this.titre,
    required this.description,
    required this.dateHeure,
    required this.lieu,
    required this.categorie,
    this.scorePertinence = 1.0,
    required this.region,
  });

  factory ActiviteIA.fromJson(Map<String, dynamic> json) {
    return ActiviteIA(
      id: _parseInt(json['id']),
      titre: json['titre'] ?? json['title'] ?? 'Activité',
      description: json['description'] ?? '',
      dateHeure: _parseDate(json['dateHeure']),
      lieu: json['lieu'] ?? json['location'] ?? 'Lieu non spécifié',
      categorie: json['categorie'] ?? 'Général',
      scorePertinence: _parseDouble(json['score_pertinence']),
      region: json['region'] ?? 'Inconnue',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 1.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 1.0;
  }

  static DateTime _parseDate(dynamic value) {
    try {
      if (value == null) return DateTime.now();
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }
}
