import 'package:flutter/material.dart';
import '../../config/app_constant.dart';

class DetailMedicationScreen extends StatefulWidget {
  final String medicationId;
  final String medicationName;
  final String dosage;
  final String mealInstruction; // 'Sebelum Makan' atau 'Setelah Makan'

  const DetailMedicationScreen({
    super.key,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.mealInstruction,
  });

  @override
  State<DetailMedicationScreen> createState() => _DetailMedicationScreenState();
}

class _DetailMedicationScreenState extends State<DetailMedicationScreen> {
  bool _isAlarmEnabled = true;

  // Data dummy jadwal minum hari ini
  final List<DoseSchedule> _todaySchedules = [
    DoseSchedule(
      id: '1',
      time: '08.00',
      timeLabel: 'Pagi',
      doseLabel: 'Dosis 1',
      doseInfo: '1 tablet (500mg)',
      status: DoseStatus.taken,
      takenTime: '08.05',
    ),
    DoseSchedule(
      id: '2',
      time: '14.00',
      timeLabel: 'Siang',
      doseLabel: 'Dosis 2',
      doseInfo: '1 tablet (500mg)',
      status: DoseStatus.upcoming,
      hoursRemaining: 2,
    ),
    DoseSchedule(
      id: '3',
      time: '20.00',
      timeLabel: 'Malam',
      doseLabel: 'Dosis 3',
      doseInfo: '1 tablet (500mg)',
      status: DoseStatus.upcoming,
      isTonight: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMedicationHeader(),
            const SizedBox(height: 20),
            _buildTodayScheduleSection(),
            const SizedBox(height: 20),
            _buildInstructionSection(),
            const SizedBox(height: 20),
            _buildAlarmSection(),
            const SizedBox(height: 24),
            _buildMarkAsTakenButton(),
            const SizedBox(height: 16),
            _buildDeleteButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ───────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Detail Obat - ${widget.medicationName}',
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.grey, size: 22),
          onPressed: _showDeleteConfirmation,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppColors.lightBlue,
            child: const Icon(Icons.person, color: AppColors.primary, size: 20),
          ),
        ),
      ],
    );
  }

  // ─── Medication Header ─────────────────────────────────────
  Widget _buildMedicationHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.medication, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.primary, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Jadwal Aktif Hari Ini',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.medicationName,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.dosage,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Today's Schedule ──────────────────────────────────────
  Widget _buildTodayScheduleSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jadwal Minum Hari Ini',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 16),
          ..._todaySchedules.map((schedule) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DoseScheduleItem(schedule: schedule),
              )),
        ],
      ),
    );
  }

  // ─── Instruction Section ───────────────────────────────────
  Widget _buildInstructionSection() {
    final isBeforeMeal = widget.mealInstruction == 'Sebelum Makan';
    final instructionText = isBeforeMeal
        ? 'Minum 30 menit sebelum makan untuk penyerapan optimal.'
        : 'Minum 15-30 menit setelah sarapan atau makan siang untuk menjaga kenyamanan lambung.';
    final instructionTitle = isBeforeMeal ? 'Sebelum Makan (Perut Kosong)' : 'Sesudah Makan (Perut Terisi)';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Petunjuk & Aturan Konsumsi',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.lightBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.restaurant, color: AppColors.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instructionTitle,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        instructionText,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Alarm Section ─────────────────────────────────────────
  Widget _buildAlarmSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.alarm, color: AppColors.primary, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Alarm Pengingat',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
          ),
          Switch(
            value: _isAlarmEnabled,
            onChanged: (value) {
              setState(() {
                _isAlarmEnabled = value;
              });
              // TODO: Update status alarm di database
              print('Alarm ${value ? 'diaktifkan' : 'dinonaktifkan'}');
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // ─── Mark as Taken Button ──────────────────────────────────
  Widget _buildMarkAsTakenButton() {
    // Cari dosis yang statusnya 'ready' (tepat waktu)
    final readyDose = _todaySchedules.firstWhere(
      (s) => s.status == DoseStatus.ready,
      orElse: () => DoseSchedule(
        id: '',
        time: '',
        timeLabel: '',
        doseLabel: '',
        doseInfo: '',
        status: DoseStatus.upcoming,
      ),
    );

    // Hanya tampilkan jika ada dosis yang ready
    if (readyDose.id.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _handleMarkAsTaken(readyDose),
        icon: const Icon(Icons.check_circle_outline, size: 20),
        label: Text(
          'Tandai Dosis ${readyDose.timeLabel} Sudah Diminum',
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
      ),
    );
  }

  // ─── Delete Button ─────────────────────────────────────────
  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _showDeleteConfirmation,
        icon: const Icon(Icons.delete_outline, color: const Color(0xFFE53935), size: 20),
        label: const Text(
          'Hapus Obat Ini',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE53935),
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Color(0xFFE53935)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _handleMarkAsTaken(DoseSchedule dose) {
    setState(() {
      final index = _todaySchedules.indexWhere((s) => s.id == dose.id);
      if (index != -1) {
        _todaySchedules[index] = _todaySchedules[index].copyWith(
          status: DoseStatus.taken,
          takenTime: DateTime.now().hour.toString().padLeft(2, '0') + '.' + 
                    DateTime.now().minute.toString().padLeft(2, '0'),
        );
      }
    });
    // TODO: Simpan ke database
    print('Dosis ${dose.doseLabel} ditandai sudah diminum');
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Obat?',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${widget.medicationName}? Semua jadwal pengingat akan dihapus.',
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            color: AppColors.grey,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: AppColors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleDeleteMedication();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDeleteMedication() {
    // TODO: Hapus dari database
    print('Obat ${widget.medicationName} dihapus');
    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════

enum DoseStatus { taken, upcoming, ready }

class DoseSchedule {
  final String id;
  final String time;
  final String timeLabel;
  final String doseLabel;
  final String doseInfo;
  final DoseStatus status;
  final String? takenTime;
  final int? hoursRemaining;
  final bool isTonight;

  const DoseSchedule({
    required this.id,
    required this.time,
    required this.timeLabel,
    required this.doseLabel,
    required this.doseInfo,
    required this.status,
    this.takenTime,
    this.hoursRemaining,
    this.isTonight = false,
  });

  DoseSchedule copyWith({
    String? id,
    String? time,
    String? timeLabel,
    String? doseLabel,
    String? doseInfo,
    DoseStatus? status,
    String? takenTime,
    int? hoursRemaining,
    bool? isTonight,
  }) {
    return DoseSchedule(
      id: id ?? this.id,
      time: time ?? this.time,
      timeLabel: timeLabel ?? this.timeLabel,
      doseLabel: doseLabel ?? this.doseLabel,
      doseInfo: doseInfo ?? this.doseInfo,
      status: status ?? this.status,
      takenTime: takenTime ?? this.takenTime,
      hoursRemaining: hoursRemaining ?? this.hoursRemaining,
      isTonight: isTonight ?? this.isTonight,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

class _DoseScheduleItem extends StatelessWidget {
  final DoseSchedule schedule;

  const _DoseScheduleItem({required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildStatusIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${schedule.time} WIB',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    if (schedule.timeLabel.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(${schedule.timeLabel})',
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${schedule.doseLabel} • ${schedule.doseInfo}',
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
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;
    Color bgColor;

    switch (schedule.status) {
      case DoseStatus.taken:
        icon = Icons.check;
        color = Colors.white;
        bgColor = AppColors.primary;
        break;
      case DoseStatus.ready:
        icon = Icons.alarm;
        color = AppColors.primary;
        bgColor = Colors.white;
        break;
      case DoseStatus.upcoming:
      default:
        icon = schedule.isTonight ? Icons.nightlight_round : Icons.alarm;
        color = AppColors.grey;
        bgColor = Colors.white;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: schedule.status != DoseStatus.taken
            ? Border.all(color: AppColors.lightBlue)
            : null,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildStatusBadge() {
    switch (schedule.status) {
      case DoseStatus.taken:
        return Text(
          'Selesai ${schedule.takenTime}',
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        );
      case DoseStatus.ready:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Dalam ${schedule.hoursRemaining} Jam',
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
      case DoseStatus.upcoming:
      default:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          ),
          child: Text(
            schedule.isTonight ? 'Malam Ini' : 'Belum',
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        );
    }
  }
}