class FoodModel {
  final String? id;
  final String name;
  final int calories;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FoodModel({
    this.id,
    required this.name,
    required this.calories,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      id: map['id']?.toString(),
      name: map['name'].toString(),
      calories: (map['calories'] as num).toInt(),
      description: map['description']?.toString(),
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
      'name': name,
      'calories': calories,
      'description': description,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }
}
