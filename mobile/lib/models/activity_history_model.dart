class ActivityHistoryModel {
  final String? id;
  final String? medicationScheduleId;
  final String? mealScheduleId;
  final String status;
  final String? note;
  final DateTime activityTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ActivityHistoryModel({
    this.id,
    this.medicationScheduleId,
    this.mealScheduleId,
    required this.status,
    this.note,
    required this.activityTime,
    this.createdAt,
    this.updatedAt,
  });

  factory ActivityHistoryModel.fromMap(Map<String, dynamic> map) {
    return ActivityHistoryModel(
      id: map['id']?.toString(),
      medicationScheduleId: map['medication_schedule_id']?.toString(),
      mealScheduleId: map['meal_schedule_id']?.toString(),
      status: map['status'].toString(),
      note: map['note']?.toString(),
      activityTime: DateTime.parse(map['activity_time'].toString()),
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
      'medication_schedule_id': medicationScheduleId,
      'meal_schedule_id': mealScheduleId,
      'status': status,
      'note': note,
      'activity_time': activityTime.toIso8601String(),
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
