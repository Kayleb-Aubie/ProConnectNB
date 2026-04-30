enum Autorisation { lecture, ecriture, complete }
enum StatutPartage { enAttente, actif, refuse }

class PartageSuivi {
  final int id;
  final Autorisation autorisation;
  final String relation; 
  final int aineId;
  final int procheAidantId;
  final StatutPartage statut;

  PartageSuivi({
    required this.id,
    required this.autorisation,
    required this.relation, 
    required this.aineId,
    required this.procheAidantId,
    this.statut = StatutPartage.enAttente,
  });

  // =========================
  // FROM JSON (Backend -> App)
  // =========================
  factory PartageSuivi.fromJson(Map<String, dynamic> json) {
    return PartageSuivi(
      id: _parseInt(json['id']),
      autorisation: _parseAutorisation(json['autorisation']),
      relation: json['relation'] ?? 'Non spécifiée', // Gestion du null
      aineId: _parseInt(json['aineId']),
      procheAidantId: _parseInt(json['procheAidantId']),
    );
  }

  // =========================
  // TO JSON (App -> Upsert DTO)
  // =========================
  Map<String, dynamic> toJson() {
    return {
      'autorisation': autorisation.name, // Convertit l'enum en String (ex: "lecture")
      'relation': relation,
      'aineId': aineId,
      'procheAidantId': procheAidantId,
    };
  }

  // =========================
  // COPY WITH (Utile pour l'UI)
  // =========================
  PartageSuivi copyWith({
    int? id,
    Autorisation? autorisation,
    String? relation,
    int? aineId,
    int? procheAidantId,
  }) {
    return PartageSuivi(
      id: id ?? this.id,
      autorisation: autorisation ?? this.autorisation,
      relation: relation ?? this.relation,
      aineId: aineId ?? this.aineId,
      procheAidantId: procheAidantId ?? this.procheAidantId,
    );
  }

  // =========================
  // HELPERS DE PARSING
  // =========================
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static Autorisation _parseAutorisation(dynamic value) {
    if (value == null) return Autorisation.lecture;
    
    String val = value.toString().toLowerCase();
    if (val.contains('ecriture')) return Autorisation.ecriture;
    if (val.contains('complete')) return Autorisation.complete;
    return Autorisation.lecture;
  }

  @override
  String toString() {
    return 'PartageSuivi(ID: $id, $relation, Droit: ${autorisation.name})';
  }
}