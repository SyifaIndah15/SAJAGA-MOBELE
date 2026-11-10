import 'package:flutter/material.dart';
import '../../config/app_constant.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container( // <-- TAMBAHAN: Background lingkaran untuk ikon
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 18,
        color: AppColors.grey,
      ),
    );
  }
}