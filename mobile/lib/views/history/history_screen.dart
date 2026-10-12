import 'package:flutter/material.dart';
import '../../config/app_constant.dart';
import 'medication_history_screen.dart';
import 'meal_history_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _selectedTab = 0; // 0 = Obat, 1 = Makanan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Riwayat Aktivitas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // Tab Obat dan Makanan
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildTab('Obat', 0),
                _buildTab('Makanan', 1),
              ],
            ),
          ),

          // Konten tab terpisah
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: const [
                MedicationHistoryScreen(),
                MealHistoryScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTab = index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w400,
              color: isSelected
                  ? AppColors.white
                  : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
