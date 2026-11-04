import 'package:flutter/material.dart';
import '../../config/app_constant.dart';

class FoodItem {
  final String id;
  final String name;
  final int calories;
  final String description;
  final String imageUrl;
  final String category;
  final List<String> tags;
  final String summary;
  final int protein;
  final int carbs;
  final int fat;
  final int prepMinutes;
  final List<String> ingredients;
  final List<String> benefits;
  final List<String> cautions;

  const FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.description,
    required this.imageUrl,
    this.category = 'Makanan Sehat',
    this.tags = const [],
    this.summary = '',
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.prepMinutes = 15,
    this.ingredients = const [],
    this.benefits = const [],
    this.cautions = const [],
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? 'Tanpa nama').toString(),
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      description: (map['description'] ?? '').toString(),
      imageUrl: (map['image_url'] ?? '').toString(),
      category: (map['category'] ?? 'Makanan Sehat').toString(),
      tags: map['tags'] is List
          ? (map['tags'] as List).map((e) => e.toString()).toList()
          : const [],
      summary: (map['summary'] ?? '').toString(),
      protein: (map['protein'] as num?)?.toInt() ?? 0,
      carbs: (map['carbs'] as num?)?.toInt() ?? 0,
      fat: (map['fat'] as num?)?.toInt() ?? 0,
      prepMinutes: (map['prep_minutes'] as num?)?.toInt() ?? 15,
      ingredients: map['ingredients'] is List
          ? (map['ingredients'] as List)
              .map((e) => e.toString())
              .toList()
          : const [],
      benefits: map['benefits'] is List
          ? (map['benefits'] as List)
              .map((e) => e.toString())
              .toList()
          : const [],
      cautions: map['cautions'] is List
          ? (map['cautions'] as List)
              .map((e) => e.toString())
              .toList()
          : const [],
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodItem food;
  final VoidCallback? onTap;

  const FoodCard({
    super.key,
    required this.food,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFFEAF0F6),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withOpacity(0.035),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: _FoodImage(
                    imageUrl: food.imageUrl,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 5,
                      runSpacing: 4,
                      children: [
                        _Tag(
                          text: food.category,
                          background: AppColors.lightBlue,
                          foreground: AppColors.primary,
                        ),

                        if (food.tags.isNotEmpty)
                          _Tag(
                            text: food.tags.first,
                            background: const Color(0xFFFFF1E6),
                            foreground: const Color(0xFFB96820),
                          ),
                      ],
                    ),

                    const SizedBox(height: 5),

                    Text(
                      food.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      food.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 9,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${food.calories} kkal',
                            style: const TextStyle(
                              color: AppColors.navy,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Lihat Menu',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 3),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FoodImage extends StatelessWidget {
  final String imageUrl;

  const _FoodImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _fallback();
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;

        return Container(
          color: AppColors.lightBlue,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.lightBlue,
      alignment: Alignment.center,
      child: const Icon(
        Icons.restaurant_rounded,
        color: AppColors.primary,
        size: 30,
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;

  const _Tag({
    required this.text,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}