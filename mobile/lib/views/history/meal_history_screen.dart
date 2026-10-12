import 'package:flutter/material.dart';
import '../../config/app_constant.dart';

class MealHistoryScreen extends StatelessWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 20),

        _buildDateHeader(
          'Hari Ini',
          'Rabu, 24 Mei',
          AppColors.primary,
        ),
        const SizedBox(height: 12),

        _buildMealCard(
          title: 'Sarapan Pagi',
          time: '07.15 WIB',
          icon: Icons.breakfast_dining_outlined,
        ),
        _buildMealCard(
          title: 'Makan Siang',
          time: '12.30 WIB',
          icon: Icons.wb_sunny_outlined,
        ),
        _buildMealCard(
          title: 'Makan Malam',
          time: '19.10 WIB',
          icon: Icons.nightlight_outlined,
        ),

        const SizedBox(height: 20),

        _buildDateHeader(
          'Kemarin',
          'Selasa, 23 Mei',
          AppColors.grey,
        ),
        const SizedBox(height: 12),

        _buildMealCard(
          title: 'Sarapan Pagi',
          time: '07.20 WIB',
          icon: Icons.breakfast_dining_outlined,
        ),
        _buildMealCard(
          title: 'Makan Siang',
          time: '12.45 WIB',
          icon: Icons.wb_sunny_outlined,
        ),
        _buildMealCard(
          title: 'Makan Malam',
          time: '19.15 WIB',
          icon: Icons.nightlight_outlined,
        ),
      ],
    );
  }

  // Ringkasan pola makan
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.white,
            AppColors.lightBlue,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightBlue,
        ),
      ),
      child: Row(
        children: [
          _buildIcon(
            Icons.restaurant,
            size: 22,
          ),
          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '100% Pola Makan Teratur',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.circle,
                      size: 7,
                      color: Color(0xFF10B981),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '3 dari 3 jadwal makan hari ini selesai tepat waktu',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Optimal',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Judul kelompok tanggal
  Widget _buildDateHeader(
    String title,
    String date,
    Color dotColor,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: dotColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const Spacer(),
        Text(
          date,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  // Kartu riwayat makan
  Widget _buildMealCard({
    required String title,
    required String time,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightBlue,
        ),
      ),
      child: Row(
        children: [
          _buildIcon(icon),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '$time • Tepat Waktu',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFD1FAE5),
              ),
            ),
            child: const Text(
              'Selesai',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF059669),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Ikon dengan lingkaran biru muda
  Widget _buildIcon(
    IconData icon, {
    double size = 20,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: size,
        color: AppColors.primary,
      ),
    );
  }
}
