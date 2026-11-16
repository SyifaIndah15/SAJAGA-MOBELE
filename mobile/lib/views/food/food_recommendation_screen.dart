import 'package:flutter/material.dart';

import '../../config/app_constant.dart';
import '../../utils/snackbar_helper.dart';
import '../widgets/food_card.dart';
import 'food_detail_screen.dart';
import '../../services/food_service.dart';

class FoodRecommendationScreen extends StatefulWidget {
  const FoodRecommendationScreen({super.key});

  @override
  State<FoodRecommendationScreen> createState() =>
      _FoodRecommendationScreenState();
}

class _FoodRecommendationScreenState extends State<FoodRecommendationScreen> {
  final TextEditingController _searchController = TextEditingController();

  final FoodService _foodService = FoodService();

  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  bool _isLoading = true;
  String? _errorMessage;

  List<FoodItem> _foods = [];

  final List<String> _filters = const [
    'Semua',
    'Sarapan',
    'Makan Siang',
    'Makan Malam',
  ];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  // Mengambil data makanan dari Supabase.
  Future<void> _loadFoods() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final response = await _foodService.getFoods();

      final foods = response.map((item) => FoodItem.fromMap(item)).toList();

      if (!mounted) return;

      setState(() {
        _foods = foods;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil data makanan: $e');

      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods {
    return _foods.where((food) {
      final matchesFilter =
          _selectedFilter == 'Semua' || food.category == _selectedFilter;

      final query = _searchQuery.toLowerCase().trim();

      final matchesSearch =
          query.isEmpty ||
          food.name.toLowerCase().contains(query) ||
          food.description.toLowerCase().contains(query) ||
          food.tags.any((tag) => tag.toLowerCase().contains(query));

      return matchesFilter && matchesSearch;
    }).toList();
  }

  void _openDetail(FoodItem food) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FoodDetailScreen(food: food)),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
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
              child: const Icon(Icons.person, color: Colors.white, size: 16),
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
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.cloud_off_outlined,
                            size: 40,
                            color: AppColors.grey,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Gagal memuat makanan',
                            style: TextStyle(
                              color: AppColors.navy,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _loadFoods,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _foods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.restaurant_outlined,
                          size: 42,
                          color: AppColors.grey,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Belum ada data makanan',
                          style: TextStyle(
                            color: AppColors.navy,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: _loadFoods,
                          child: const Text('Muat Ulang'),
                        ),
                      ],
                    ),
                  )
                : _filteredFoods.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 22),
                    itemCount: _filteredFoods.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                  style: TextStyle(color: AppColors.grey, fontSize: 9),
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
        style: const TextStyle(fontSize: 11, color: AppColors.navy),
        decoration: InputDecoration(
          hintText: 'Cari makanan sehat...',
          hintStyle: const TextStyle(fontSize: 11, color: AppColors.grey),

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
                  icon: const Icon(Icons.close_rounded, size: 17),
                ),

          filled: true,
          fillColor: const Color(0xFFF5F8FC),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),

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
        separatorBuilder: (_, __) => const SizedBox(width: 7),
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
              color: selected ? Colors.white : AppColors.grey,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),

            selectedColor: AppColors.primary,
            backgroundColor: const Color(0xFFF1F5F9),
            side: BorderSide.none,
            showCheckmark: false,

            padding: const EdgeInsets.symmetric(horizontal: 7),

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
              style: TextStyle(color: AppColors.grey, fontSize: 10),
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
                style: TextStyle(fontSize: 10, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
