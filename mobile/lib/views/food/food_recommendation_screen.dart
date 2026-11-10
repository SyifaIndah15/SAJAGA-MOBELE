import 'package:flutter/material.dart';

import '../../config/app_constant.dart';
import '../../utils/snackbar_helper.dart';
import '../widgets/food_card.dart';
import 'food_detail_screen.dart';

class FoodRecommendationScreen extends StatefulWidget {
  const FoodRecommendationScreen({super.key});

  @override
  State<FoodRecommendationScreen> createState() =>
      _FoodRecommendationScreenState();
}

class _FoodRecommendationScreenState
    extends State<FoodRecommendationScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  final List<String> _filters = const [
    'Semua',
    'Sarapan',
    'Makan Siang',
    'Makan Malam',
  ];

  // DATA CONTOH MAKANAN
  // Nantinya dapat diganti dengan data dari Supabase.

  final List<FoodItem> _foods = const [
    FoodItem(
      id: 'food-01',
      name: 'Bubur Labu Ayam Suwir',
      calories: 245,
      category: 'Sarapan',
      tags: ['Ramah Mag'],
      description:
          'Tekstur lembut yang hangat dengan gizi seimbang.',
      summary:
          'Bubur beras lembut yang dimasak perlahan bersama kaldu ayam dan sentuhan jahe.',
      imageUrl:
          'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=700',
      protein: 18,
      carbs: 32,
      fat: 6,
      prepMinutes: 30,
      ingredients: [
        'Beras putih',
        'Dada ayam suwir',
        'Labu kuning',
        'Jahe',
        'Kaldu rendah garam',
      ],
      benefits: [
        'Tekstur lembut dan mudah dikonsumsi.',
        'Mengandung protein dari ayam.',
        'Labu kuning menyediakan vitamin dan serat.',
      ],
      cautions: [
        'Sesuaikan bumbu dengan kebutuhan kesehatan.',
        'Perhatikan toleransi terhadap bahan makanan.',
      ],
    ),

    FoodItem(
      id: 'food-02',
      name: 'Sup Bening Labu Siam & Wortel',
      calories: 162,
      category: 'Makan Siang',
      tags: ['Tinggi Serat'],
      description:
          'Kuah sayur segar dengan tekstur lembut dan rasa ringan.',
      imageUrl:
          'https://images.unsplash.com/photo-1547592180-85f173990554?w=700',
      protein: 7,
      carbs: 24,
      fat: 4,
      prepMinutes: 25,
      ingredients: [
        'Labu siam',
        'Wortel',
        'Bawang putih',
        'Daun bawang',
        'Air',
      ],
      benefits: [
        'Mengandung serat dari sayuran.',
        'Kuah bening terasa ringan.',
        'Dapat menjadi pilihan menu sayur harian.',
      ],
      cautions: [
        'Batasi garam dan penyedap sesuai kebutuhan.',
      ],
    ),

    FoodItem(
      id: 'food-03',
      name: 'Oatmeal Pisang & Madu',
      calories: 220,
      category: 'Sarapan',
      tags: ['Lepas Lambung'],
      description:
          'Oatmeal dengan pisang untuk pilihan sarapan praktis.',
      imageUrl:
          'https://naoq8gawh7kpd7sm.public.blob.vercel-storage.com/Ovsena%20ka%C5%A1a%20s%20bananom%20i%20medom-5QEGAqjjxYMBEneaJeJGLypEgaa10a.webp',
      protein: 8,
      carbs: 38,
      fat: 5,
      prepMinutes: 10,
      ingredients: [
        'Oatmeal',
        'Pisang',
        'Susu rendah lemak',
        'Madu',
      ],
      benefits: [
        'Oat menyediakan serat.',
        'Pisang memberi rasa manis alami.',
        'Praktis disiapkan pada pagi hari.',
      ],
      cautions: [
        'Madu tetap mengandung gula. Sesuaikan porsinya.',
      ],
    ),

    FoodItem(
      id: 'food-04',
      name: 'Nasi Tim Ikan Kakap Kukus',
      calories: 240,
      category: 'Makan Siang',
      tags: ['Bebas Minyak'],
      description:
          'Nasi tim dengan ikan kukus dan sayuran pilihan.',
      imageUrl:
          'https://mealpractice.b-cdn.net/306719053685329920/steamed-fish-with-ginger-and-scallions-served-with-stir-fried-bok-choy-and-jasmine-rice-fH4AiLCnLg.webp',
      protein: 21,
      carbs: 29,
      fat: 5,
      prepMinutes: 35,
      ingredients: [
        'Nasi',
        'Ikan kakap',
        'Wortel',
        'Brokoli',
        'Jahe',
      ],
      benefits: [
        'Ikan menyediakan protein.',
        'Metode kukus mengurangi penggunaan minyak.',
        'Sayuran menambah variasi serat.',
      ],
      cautions: [
        'Pastikan ikan matang sempurna dan bebas duri.',
      ],
    ),

    FoodItem(
      id: 'food-05',
      name: 'Sayur Bening Bayam Jagung Manis',
      calories: 110,
      category: 'Makan Siang',
      tags: ['Zat Besi Alami'],
      description:
          'Sayuran berkuah ringan dengan jagung manis.',
      imageUrl:
          'https://images.unsplash.com/photo-1547592180-85f173990554?w=700',
      protein: 5,
      carbs: 18,
      fat: 2,
      prepMinutes: 15,
      ingredients: [
        'Bayam',
        'Jagung manis',
        'Bawang merah',
        'Temu kunci',
      ],
      benefits: [
        'Bayam mengandung beberapa mineral.',
        'Jagung memberi rasa manis alami.',
        'Kuah bening mudah dipadukan dengan lauk.',
      ],
      cautions: [
        'Konsumsi dalam kondisi segar dan matang.',
      ],
    ),

    FoodItem(
      id: 'food-06',
      name: 'Pepes Tahu Jamur Daun Kemangi',
      calories: 180,
      category: 'Makan Malam',
      tags: ['Bebas Santan'],
      description:
          'Pepes tahu dengan jamur dan aroma daun kemangi.',
      imageUrl:
          'https://images.unsplash.com/photo-1547592180-85f173990554?w=700',
      protein: 13,
      carbs: 12,
      fat: 8,
      prepMinutes: 30,
      ingredients: [
        'Tahu',
        'Jamur',
        'Daun kemangi',
        'Tomat',
        'Daun pisang',
      ],
      benefits: [
        'Tahu merupakan sumber protein nabati.',
        'Dimasak dengan cara dikukus.',
        'Menghadirkan variasi menu tanpa santan.',
      ],
      cautions: [
        'Sesuaikan penggunaan garam dan bumbu.',
      ],
    ),

    FoodItem(
      id: 'food-07',
      name: 'Sup Ayam Kampung Kuah Jahe',
      calories: 230,
      category: 'Makan Malam',
      tags: ['Saring Kuah'],
      description:
          'Sup ayam hangat dengan kuah jahe yang ringan.',
      imageUrl:
          'https://images.unsplash.com/photo-1547592180-85f173990554?w=700',
      protein: 20,
      carbs: 14,
      fat: 9,
      prepMinutes: 40,
      ingredients: [
        'Ayam kampung',
        'Jahe',
        'Wortel',
        'Daun bawang',
      ],
      benefits: [
        'Ayam menyediakan protein.',
        'Kuah hangat cocok sebagai menu berkuah.',
        'Sayuran menambah variasi nutrisi.',
      ],
      cautions: [
        'Buang lemak berlebih dan sesuaikan bumbu.',
      ],
    ),

    FoodItem(
      id: 'food-08',
      name: 'Ikan Salmon Panggang Lemon Herbal',
      calories: 360,
      category: 'Makan Malam',
      tags: ['Anti-inflamasi'],
      description:
          'Ikan salmon panggang dengan lemon dan rempah.',
      imageUrl:
          'https://res.cloudinary.com/solin-fitness/image/upload/c_scale%2Cw_800%2Cq_auto%2Cf_auto/single-meal-images/bfatcaww9ecejexbaaud',
      protein: 28,
      carbs: 10,
      fat: 20,
      prepMinutes: 25,
      ingredients: [
        'Ikan salmon',
        'Lemon',
        'Rosemary',
        'Lada',
        'Minyak zaitun',
      ],
      benefits: [
        'Salmon mengandung protein dan lemak omega-3.',
        'Dipanggang dengan penggunaan minyak terukur.',
        'Lemon dan rempah memberi aroma.',
      ],
      cautions: [
        'Perhatikan alergi ikan dan kebutuhan lemak harian.',
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods {
    return _foods.where((food) {
      final matchesFilter =
          _selectedFilter == 'Semua' ||
          food.category == _selectedFilter;

      final query = _searchQuery.toLowerCase().trim();

      final matchesSearch =
          query.isEmpty ||
          food.name.toLowerCase().contains(query) ||
          food.description.toLowerCase().contains(query) ||
          food.tags.any(
            (tag) => tag.toLowerCase().contains(query),
          );

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _openDetail(FoodItem food) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailScreen(food: food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),

        title: const Text(
          'Rekomendasi Makanan Sehat',
          style: TextStyle(
            color: AppColors.navy,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
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

      body: Column(
        children: [
          _buildIntro(),
          _buildSearch(),
          _buildFilters(),

          Expanded(
            child: _filteredFoods.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      14, 8, 14, 22,
                    ),
                    itemCount: _filteredFoods.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final food = _filteredFoods[index];

                      return FoodCard(
                        food: food,
                        onTap: () => _openDetail(food),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // INTRO SECTION

  Widget _buildIntro() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
      color: AppColors.white,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.primary,
              size: 19,
            ),
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilihan makanan sehat',
                  style: TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Temukan menu yang sesuai dengan kebutuhanmu.',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SEARCH SECTION

  Widget _buildSearch() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(14, 2, 14, 12),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.navy,
        ),
        decoration: InputDecoration(
          hintText: 'Cari makanan sehat...',
          hintStyle: const TextStyle(
            fontSize: 11,
            color: AppColors.grey,
          ),

          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
            size: 19,
          ),

          suffixIcon: _searchQuery.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();

                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 17,
                  ),
                ),

          filled: true,
          fillColor: const Color(0xFFF5F8FC),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // FILTER SECTION

  Widget _buildFilters() {
    return Container(
      color: AppColors.white,
      height: 48,
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final selected = filter == _selectedFilter;

          return ChoiceChip(
            label: Text(filter),
            selected: selected,

            onSelected: (_) {
              setState(() {
                _selectedFilter = filter;
              });
            },

            labelStyle: TextStyle(
              color: selected
                  ? Colors.white
                  : AppColors.grey,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),

            selectedColor: AppColors.primary,
            backgroundColor: const Color(0xFFF1F5F9),
            side: BorderSide.none,
            showCheckmark: false,

            padding: const EdgeInsets.symmetric(
              horizontal: 7,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }

  // EMPTY STATE

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: AppColors.secondary,
              size: 42,
            ),

            const SizedBox(height: 10),

            const Text(
              'Makanan tidak ditemukan',
              style: TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Coba kata kunci atau kategori lainnya.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 10,
              ),
            ),

            TextButton(
              onPressed: () {
                _searchController.clear();

                setState(() {
                  _searchQuery = '';
                  _selectedFilter = 'Semua';
                });

                SnackbarHelper.showSuccess(
                  context,
                  'Filter berhasil diatur ulang.',
                );
              },
              child: const Text(
                'Atur ulang filter',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}