class NotificationSettingsModel {
  final String? id;
  final String userId;
  final bool medicationReminder;
  final bool mealReminder;
  final bool soundVibration;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NotificationSettingsModel({
    this.id,
    required this.userId,
    this.medicationReminder = true,
    this.mealReminder = true,
    this.soundVibration = true,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationSettingsModel.fromMap(Map<String, dynamic> map) {
    return NotificationSettingsModel(
      id: map['id']?.toString(),
      userId: map['user_id'].toString(),
      medicationReminder: map['medication_reminder'] as bool? ?? true,
      mealReminder: map['meal_reminder'] as bool? ?? true,
      soundVibration: map['sound_vibration'] as bool? ?? true,
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
      'medication_reminder': medicationReminder,
      'meal_reminder': mealReminder,
      'sound_vibration': soundVibration,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
