import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap; // <-- TAMBAHAN: Agar bisa diklik
  final Widget child;

  const ProfileSection({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1E293B), // Sesuai desain
                ),
              ),
              if (actionText != null)
                GestureDetector( // <-- TAMBAHAN: Agar bisa diklik
                  onTap: onActionTap,
                  child: Text(
                    actionText!,
                    style: const TextStyle(
                      color: Color(0xff008ACB),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}