import 'package:flutter/material.dart';

enum ActivityBadgeType {
  diminum,
  terlewat,
  selesai,
  optimal,
  akanDatang,
  custom,
}

class ActivityStatusBadge extends StatelessWidget {
  final String label;
  final ActivityBadgeType type;
  final Color? customBgColor;
  final Color? customTextColor;

  const ActivityStatusBadge({
    super.key,
    required this.label,
    this.type = ActivityBadgeType.custom,
    this.customBgColor,
    this.customTextColor,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (type) {
      case ActivityBadgeType.diminum:
      case ActivityBadgeType.selesai:
      case ActivityBadgeType.optimal:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF2E7D32);
        break;
      case ActivityBadgeType.terlewat:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFC62828);
        break;
      case ActivityBadgeType.akanDatang:
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFEF6C00);
        break;
      case ActivityBadgeType.custom:
        bgColor = customBgColor ?? Colors.blue.shade50;
        textColor = customTextColor ?? Colors.blue.shade700;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}