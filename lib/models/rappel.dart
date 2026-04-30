class Rappel {
  final int id;
  final DateTime dateHeure;
  final String type;
  final bool actif;
  final int? medicamentId;
  final int? rendezVousMedicalId;

  Rappel({
    required this.id,
    required this.dateHeure,
    required this.type,
    required this.actif,
    this.medicamentId,
    this.rendezVousMedicalId,
  });

  factory Rappel.fromJson(Map<String, dynamic> json) {
    return Rappel(
      id: _parseInt(json['id']),
      dateHeure: _parseDate(json['dateHeure']),
      type: json['type'] ?? '',
      actif: json['actif'] ?? false,
      medicamentId: json['medicamentId'] == null
          ? null
          : _parseInt(json['medicamentId']),
      rendezVousMedicalId: json['rendezVousMedicalId'] == null
          ? null
          : _parseInt(json['rendezVousMedicalId']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateHeure': dateHeure.toIso8601String(),
      'type': type,
      'actif': actif,
      'medicamentId': medicamentId,
      'rendezVousMedicalId': rendezVousMedicalId,
    };
  }

  Rappel copyWith({
    int? id,
    DateTime? dateHeure,
    String? type,
    bool? actif,
    int? medicamentId,
    int? rendezVousMedicalId,
  }) {
    return Rappel(
      id: id ?? this.id,
      dateHeure: dateHeure ?? this.dateHeure,
      type: type ?? this.type,
      actif: actif ?? this.actif,
      medicamentId: medicamentId ?? this.medicamentId,
      rendezVousMedicalId: rendezVousMedicalId ?? this.rendezVousMedicalId,
    );
  }

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
    return 'Rappel(type: $type, actif: $actif, date: $dateHeure)';
  }
}
