import 'package:flutter/material.dart';
import '../../config/app_constant.dart';

enum MedicationStatus {
  upcoming,      // Belum waktunya (> 1 jam lagi)
  ready,         // Tepat waktu (dalam window 5 menit)
  taken,         // Sudah diminum
  late,          // Terlewat < 1 jam (5 menit - 1 jam)
  missed         // Terlewat > 1 jam
}

class MedicationCard extends StatelessWidget {
  final String time;
  final String timeLabel;
  final String medicationName;
  final String dosage;
  final MedicationStatus status;
  final int? lateMinutes; // Jumlah menit keterlambatan (jika ada)
  final VoidCallback? onTapCheck;
  final VoidCallback? onTapMinumSekarang;
  final VoidCallback? onTapAturJadwal;
  final VoidCallback? onTapAturUlang;

  const MedicationCard({
    super.key,
    required this.time,
    required this.timeLabel,
    required this.medicationName,
    required this.dosage,
    required this.status,
    this.lateMinutes,
    this.onTapCheck,
    this.onTapMinumSekarang,
    this.onTapAturJadwal,
    this.onTapAturUlang,
  });

@override
Widget build(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Tambahkan ini
          children: [
            _buildTimeIcon(),
            const SizedBox(width: 12),
            Expanded( // Pastikan Expanded ada di sini
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '$time $timeLabel',
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicationName,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dosage,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            _buildActionArea(),
          ],
        ),
        // Tampilkan warning jika terlambat
        if (status == MedicationStatus.late || status == MedicationStatus.missed)
          _buildLateWarning(),
      ],
    ),
  );
}

  Widget _buildTimeIcon() {
    final isMorning = timeLabel.toLowerCase().contains('pagi');
    final isAfternoon = timeLabel.toLowerCase().contains('siang');
    final isNight = timeLabel.toLowerCase().contains('malam');
    
    IconData icon;
    Color iconColor;
    
    if (isMorning) {
      icon = Icons.wb_sunny_outlined;
      iconColor = AppColors.primary;
    } else if (isAfternoon) {
      icon = Icons.wb_sunny;
      iconColor = AppColors.primary;
    } else if (isNight) {
      icon = Icons.nightlight_round;
      iconColor = const Color(0xFFFF9800);
    } else {
      icon = Icons.access_time;
      iconColor = AppColors.grey;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isNight ? const Color(0xFFFFF3E0) : AppColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case MedicationStatus.upcoming:
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFFF9800);
        label = 'Akan Datang';
        break;
      case MedicationStatus.ready:
        bgColor = AppColors.lightBlue;
        textColor = AppColors.primary;
        label = 'Siap Diminum';
        break;
      case MedicationStatus.taken:
        bgColor = AppColors.lightBlue;
        textColor = AppColors.primary;
        label = 'Diminum';
        break;
      case MedicationStatus.late:
        bgColor = const Color(0xFFFFF3E0);
        textColor = const Color(0xFFFF9800);
        label = 'Terlewatkan';
        break;
      case MedicationStatus.missed:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFE53935);
        label = 'Terlewat';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildActionArea() {
    switch (status) {
      case MedicationStatus.taken:
        // Sudah diminum - tampilkan centang read-only
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 20),
        );

      case MedicationStatus.ready:
        // Tepat waktu - tampilkan tombol centang yang bisa diklik
        return GestureDetector(
          onTap: onTapCheck,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Icon(Icons.check, color: AppColors.primary, size: 20),
          ),
        );

      case MedicationStatus.late:
        // Terlewat < 1 jam - tampilkan tombol "Minum Sekarang"
        return GestureDetector(
          onTap: onTapMinumSekarang,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.medication, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text('Minum Sekarang',
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ],
            ),
          ),
        );

      case MedicationStatus.missed:
        // Terlewat > 1 jam - tampilkan tombol "Atur Jadwal"
        return GestureDetector(
          onTap: onTapAturJadwal,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text('Atur Jadwal',
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ],
            ),
          ),
        );

      case MedicationStatus.upcoming:
      default:
        // Belum waktunya - tidak ada tombol
        return const SizedBox.shrink();
    }
  }

  Widget _buildLateWarning() {
    if (status == MedicationStatus.late && lateMinutes != null) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF9800), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Jadwal terlewat $lateMinutes menit yang lalu',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  color: Color(0xFFFF9800),
                ),
              ),
            ),
          ],
        ),
      );
    } else if (status == MedicationStatus.missed) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE53935).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFE53935), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Jadwal terlewat lebih dari 1 jam. Silakan sesuaikan kembali jadwal minum obat Anda agar dosis tetap aman.',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onTapAturUlang,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE53935)),
                  ),
                  child: const Text(
                    'Atur Ulang',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}