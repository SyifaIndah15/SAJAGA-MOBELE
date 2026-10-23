class MealScheduleModel {
  final String? id;
  final String userId;
  final String mealType;
  final String scheduleTime;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MealScheduleModel({
    this.id,
    required this.userId,
    required this.mealType,
    required this.scheduleTime,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory MealScheduleModel.fromMap(Map<String, dynamic> map) {
    return MealScheduleModel(
      id: map['id']?.toString(),
      userId: map['user_id'].toString(),
      mealType: map['meal_type'].toString(),
      scheduleTime: map['schedule_time'].toString(),
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
      'user_id': userId,
      'meal_type': mealType,
      'schedule_time': scheduleTime,
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
