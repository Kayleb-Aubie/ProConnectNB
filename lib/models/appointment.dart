class RendezVousMedical {
  final int id;
  final DateTime dateHeure;
  final String lieu;
  final String docteur;
  final String notes;
  final int aineId;

  RendezVousMedical({
    required this.id,
    required this.dateHeure,
    required this.lieu,
    required this.docteur,
    this.notes = '',
    required this.aineId,
  });

  // =========================
  // FROM JSON (ROBUSTE)
  // =========================
  factory RendezVousMedical.fromJson(Map<String, dynamic> json) {
    return RendezVousMedical(
      id: _parseInt(json['id']),
      dateHeure: _parseDate(json['dateHeure']),
      lieu: json['lieu'] ?? '',
      docteur: json['docteur'] ?? '',
      notes: json['notes'] ?? '',
      aineId: _parseInt(json['aineId']),
    );
  }

  // =========================
  // TO JSON (BACKEND)
  // =========================
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "dateHeure": dateHeure.toIso8601String(),
      "lieu": lieu,
      "docteur": docteur,
      "notes": notes,
      "aineId": aineId,
    };
  }

  // =========================
  // COPY WITH (UI)
  // =========================
  RendezVousMedical copyWith({
    int? id,
    DateTime? dateHeure,
    String? lieu,
    String? docteur,
    String? notes,
    int? aineId,
  }) {
    return RendezVousMedical(
      id: id ?? this.id,
      dateHeure: dateHeure ?? this.dateHeure,
      lieu: lieu ?? this.lieu,
      docteur: docteur ?? this.docteur,
      notes: notes ?? this.notes,
      aineId: aineId ?? this.aineId,
    );
  }

  // =========================
  // HELPERS ANTI-CRASH
  // =========================
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static DateTime _parseDate(dynamic value) {
    try {
      if (value == null) return DateTime.now();
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  @override
  String toString() {
    return 'RDV chez $docteur à $lieu le $dateHeure';
  }
}
