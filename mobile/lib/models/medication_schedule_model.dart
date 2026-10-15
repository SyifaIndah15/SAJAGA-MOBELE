class MedicationScheduleModel {
  final String? id;
  final String medicationId;
  final String scheduleTime;
  final String? mealInstruction;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MedicationScheduleModel({
    this.id,
    required this.medicationId,
    required this.scheduleTime,
    this.mealInstruction,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory MedicationScheduleModel.fromMap(Map<String, dynamic> map) {
    return MedicationScheduleModel(
      id: map['id']?.toString(),
      medicationId: map['medication_id'].toString(),
      scheduleTime: map['schedule_time'].toString(),
      mealInstruction: map['meal_instruction']?.toString(),
      isActive: map['is_active'] as bool? ?? true,
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
      'medication_id': medicationId,
      'schedule_time': scheduleTime,
      'meal_instruction': mealInstruction,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
