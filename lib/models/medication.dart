class Medication {
  final String id;
  final String name;
  final String dosage;
  final String schedule;

  // pris ou non
  final bool isTaken;

  // actif ou non pour les rappels
  final bool isActive;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.schedule,
    this.isTaken = false,
    this.isActive = false,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? schedule,
    bool? isTaken,
    bool? isActive,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      schedule: schedule ?? this.schedule,
      isTaken: isTaken ?? this.isTaken,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? json['nom'] ?? '',
      dosage: json['dosage'] ?? '',
      schedule: json['schedule'] ?? json['heure'] ?? '',
      isTaken: json['isTaken'] ?? false,
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "dosage": dosage,
      "schedule": schedule,
      "isTaken": isTaken,
      "isActive": isActive,
    };
  }
}
