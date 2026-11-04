import 'package:flutter/material.dart';

import '../../config/app_constant.dart';
import '../../utils/snackbar_helper.dart';
import '../widgets/food_card.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem food;

  const FoodDetailScreen({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailScreen> createState() =>
      _FoodDetailScreenState();
}

class _FoodDetailScreenState
    extends State<FoodDetailScreen> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: AppColors.background,
            elevation: 0,

            leading: IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
              ),
            ),

            title: const Text(
              'Detail Menu',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),

            actions: [
              IconButton(
                tooltip: 'Favorit',
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });

                  SnackbarHelper.showSuccess(
                    context,
                    _isFavorite
                        ? 'Menu ditambahkan ke favorit.'
                        : 'Menu dihapus dari favorit.',
                  );
                },

                icon: Icon(
                  _isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: _isFavorite
                      ? Colors.redAccent
                      : AppColors.navy,
                  size: 21,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.primary,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                14, 0, 14, 28,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHero(food),

                  const SizedBox(height: 13),

                  _buildTitle(food),

                  const SizedBox(height: 13),

                  _buildNutrition(food),

                  const SizedBox(height: 12),

                  _buildPreparation(food),

                  const SizedBox(height: 12),

                  _buildIngredients(food),

                  const SizedBox(height: 12),

                  _buildBenefits(food),

                  const SizedBox(height: 12),

                  _buildCautions(food),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.maybePop(context);
                      },

                      icon: const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 17,
                      ),

                      label: const Text(
                        'Mengerti',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(
                          vertical: 13,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),

                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HERO IMAGE

  Widget _buildHero(FoodItem food) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 185,

            child: food.imageUrl.isEmpty
                ? _imageFallback()
                : Image.network(
                    food.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _imageFallback(),
                  ),
          ),

          Positioned(
            left: 10,
            top: 10,
            child: _pill(
              Icons.restaurant_rounded,
              food.category,
              background: Colors.white.withOpacity(0.94),
              foreground: AppColors.primary,
            ),
          ),

          Positioned(
            right: 10,
            top: 10,
            child: _pill(
              Icons.local_fire_department_rounded,
              '${food.calories} kkal',
              background: Colors.white.withOpacity(0.94),
              foreground: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: AppColors.lightBlue,
      alignment: Alignment.center,
      child: const Icon(
        Icons.restaurant_rounded,
        color: AppColors.primary,
        size: 55,
      ),
    );
  }

  // FOOD TITLE

  Widget _buildTitle(FoodItem food) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.primary,
              size: 12,
            ),

            const SizedBox(width: 5),

            Text(
              food.category,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          food.name,
          style: const TextStyle(
            color: AppColors.navy,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          food.summary.isNotEmpty
              ? food.summary
              : food.description,

          style: const TextStyle(
            color: AppColors.grey,
            fontSize: 10,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  // NUTRITION INFORMATION

  Widget _buildNutrition(FoodItem food) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
        horizontal: 8,
      ),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFEAF0F6),
        ),
      ),

      child: Row(
        children: [
          _nutritionItem(
            'Energi',
            '${food.calories}',
            'kkal',
          ),

          _nutritionItem(
            'Karbo',
            '${food.carbs}',
            'g',
          ),

          _nutritionItem(
            'Protein',
            '${food.protein}',
            'g',
          ),

          _nutritionItem(
            'Lemak',
            '${food.fat}',
            'g',
          ),
        ],
      ),
    );
  }

  Widget _nutritionItem(
    String label,
    String value,
    String unit,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 9,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: AppColors.navy,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),

          Text(
            unit,
            style: const TextStyle(
              color: AppColors.grey,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  // PREPARATION TIME

  Widget _buildPreparation(FoodItem food) {
    return _sectionCard(
      icon: Icons.timer_outlined,

      title:
          'Estimasi Waktu Persiapan: ${food.prepMinutes} Menit',

      child: const Text(
        'Informasi ini merupakan perkiraan waktu menyiapkan menu, bukan aturan medis atau anjuran waktu konsumsi obat.',

        style: TextStyle(
          color: AppColors.grey,
          fontSize: 9,
          height: 1.5,
        ),
      ),

      tint: const Color(0xFFEAF7FF),
    );
  }

  // INGREDIENTS

  Widget _buildIngredients(FoodItem food) {
    return _sectionCard(
      icon: Icons.soup_kitchen_outlined,
      title: 'Bahan-Bahan Alami',

      child: food.ingredients.isEmpty
          ? _emptyText(
              'Informasi bahan belum tersedia.',
            )
          : Column(
              children: food.ingredients
                  .map((item) => _bullet(item))
                  .toList(),
            ),
    );
  }

  // BENEFITS

  Widget _buildBenefits(FoodItem food) {
    return _sectionCard(
      icon: Icons.health_and_safety_outlined,
      title: 'Manfaat & Pencernaan',

      child: food.benefits.isEmpty
          ? _emptyText(
              'Informasi manfaat belum tersedia.',
            )
          : Column(
              children: food.benefits
                  .map((item) => _bullet(item))
                  .toList(),
            ),
    );
  }

  // ALLERGY AND CAUTIONS

  Widget _buildCautions(FoodItem food) {
    return _sectionCard(
      icon: Icons.warning_amber_rounded,

      title: 'Perhatian Alergi & Pantangan',

      tint: const Color(0xFFFFF1F1),

      iconColor: const Color(0xFFDC4C4C),

      titleColor: const Color(0xFFB42332),

      child: food.cautions.isEmpty
          ? _emptyText(
              'Periksa kandungan bahan dan sesuaikan menu dengan kebutuhan pribadi.',
            )
          : Column(
              children: food.cautions
                  .map(
                    (item) => _bullet(
                      item,
                      color: const Color(0xFFB45353),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // REUSABLE SECTION CARD

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
    Color tint = AppColors.white,
    Color iconColor = AppColors.primary,
    Color titleColor = AppColors.navy,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),

      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFEAF0F6),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 16,
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          child,
        ],
      ),
    );
  }

  // BULLET ITEM

  Widget _bullet(
    String text, {
    Color color = AppColors.grey,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(
              top: 5,
              right: 8,
            ),

            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 9,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.grey,
        fontSize: 9,
        height: 1.45,
      ),
    );
  }

  // CATEGORY AND CALORIE BADGE

  Widget _pill(
    IconData icon,
    String text, {
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: foreground,
          ),

          const SizedBox(width: 4),

          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}