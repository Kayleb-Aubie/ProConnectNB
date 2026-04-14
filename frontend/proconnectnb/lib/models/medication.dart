class Medication {
  final int id;
  final String nom;
  final String dosage;
  final String frequence;

  Medication({
    required this.id,
    required this.nom,
    required this.dosage,
    required this.frequence,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      nom: json['nom'],
      dosage: json['dosage'],
      frequence: json['frequence'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'dosage': dosage,
      'frequence': frequence,
    };
  }
}