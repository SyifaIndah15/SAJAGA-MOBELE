class MedicationModel {
  final String? id;
  final String userId;
  final String name;
  final String dose;
  final int days;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MedicationModel({
    this.id,
    required this.userId,
    required this.name,
    required this.dose,
    required this.days,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicationModel.fromMap(Map<String, dynamic> map) {
    return MedicationModel(
      id: map['id']?.toString(),
      userId: map['user_id'].toString(),
      name: map['name'].toString(),
      dose: map['dose'].toString(),
      days: (map['days'] as num).toInt(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'].toString())
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'name': name,
      'dose': dose,
      'days': days,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
