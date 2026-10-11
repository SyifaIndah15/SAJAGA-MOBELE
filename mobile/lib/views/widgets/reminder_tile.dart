import 'package:flutter/material.dart';

class ReminderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value; // <-- TAMBAHAN: Menerima nilai switch
  final ValueChanged<bool> onChanged; // <-- TAMBAHAN: Menerima fungsi saat diklik

  const ReminderTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF64748B),
        ),
      ),
      trailing: Switch(
        value: value, // <-- Menggunakan nilai dari parent
        onChanged: onChanged, // <-- Memanggil fungsi dari parent
        activeColor: const Color(0xff008ACB),
        activeTrackColor: const Color(0xff008ACB).withOpacity(0.5),
      ),
    );
  }
}