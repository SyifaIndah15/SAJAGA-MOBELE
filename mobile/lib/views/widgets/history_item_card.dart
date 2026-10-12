import 'package:flutter/material.dart';
import '../../config/app_constant.dart';

class HistoryItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final bool isSuccess; // <-- TAMBAHAN: Untuk menentukan warna badge

  const HistoryItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.isSuccess = true, // Default hijau
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan status
    final badgeColor = isSuccess ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
    final badgeBgColor = isSuccess ? const Color(0xffDDF5E8) : const Color(0xFFFFF3E0);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12), // Sedikit diperkecil agar lebih proporsional
      ),
      child: Row(
        children: [
          // Ikon dengan background kotak kecil (sesuai Figma)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
        }
}