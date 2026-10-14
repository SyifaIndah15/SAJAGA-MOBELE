import 'package:flutter/material.dart';

class MealScheduleCard extends StatelessWidget {
  final IconData icon;
  final String mealTitle;
  final String mealSubtitle;
  final String time;
  final bool isEnabled;
  final ValueChanged<bool> onSwitchChanged;
  final VoidCallback? onTapTime;

  const MealScheduleCard({
    super.key,
    required this.icon,
    required this.mealTitle,
    required this.mealSubtitle,
    required this.time,
    required this.isEnabled,
    required this.onSwitchChanged,
    this.onTapTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.blue.shade700, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mealSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTapTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isEnabled,
            onChanged: onSwitchChanged,
            activeColor: Colors.blue.shade700,
          ),
        ],
      ),
    );
  }
}