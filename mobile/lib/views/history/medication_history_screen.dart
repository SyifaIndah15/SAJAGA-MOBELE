import 'package:flutter/material.dart';
import '../../config/app_constant.dart';

class MedicationHistoryScreen extends StatelessWidget {
  const MedicationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 24),

        _buildDateHeader(
          'Hari Ini',
          'Rabu, 24 Mei',
          AppColors.primary,
        ),
        const SizedBox(height: 12),

        _buildMedicationCard(
          name: 'Antasida Doen',
          dosage: '',
          time: '07.30 WIB',
          instruction: 'Sebelum Makan',
          icon: Icons.medication,
        ),
        _buildMedicationCard(
          name: 'Paracetamol',
          dosage: '500mg',
          time: '08.05 WIB',
          instruction: 'Tepat Waktu',
          icon: Icons.medication_outlined,
        ),
        _buildMedicationCard(
          name: 'Amoxicillin',
          dosage: '500mg',
          time: '13.00 WIB',
          instruction: 'Tepat Waktu',
          icon: Icons.medication_outlined,
        ),
        _buildMedicationCard(
          name: 'Vitamin B Kompleks',
          dosage: '',
          time: '19.30 WIB',
          instruction: 'Tepat Waktu',
          icon: Icons.medication_outlined,
        ),

        const SizedBox(height: 24),

        _buildDateHeader(
          'Kemarin',
          'Selasa, 23 Mei',
          AppColors.grey,
        ),
        const SizedBox(height: 12),

        _buildMedicationCard(
          name: 'Paracetamol',
          dosage: '500mg',
          time: '08.00 WIB',
          instruction: 'Tepat Waktu',
          icon: Icons.medication_outlined,
        ),
        _buildMedicationCard(
          name: 'Amoxicillin',
          dosage: '500mg',
          time: '12.45 WIB',
          instruction: 'Tepat Waktu',
          icon: Icons.medication_outlined,
        ),
        _buildMedicationCard(
          name: 'Vitamin C',
          dosage: '500mg',
          time: '20.00 WIB',
          instruction: 'Tepat Waktu',
          icon: Icons.medication_outlined,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SUMMARY CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, AppColors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          _buildSummaryIcon(),
          const SizedBox(width: 12),
          Expanded(child: _buildSummaryText()),
          const SizedBox(width: 8),
          _buildSummaryBadge(),
        ],
      ),
    );
  }

  Widget _buildSummaryIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_outline,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  Widget _buildSummaryText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '100% Kepatuhan Minum Obat',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
          ],
        ),
        SizedBox(height: 2),
        Text(
          '4 dari 4 jadwal obat hari ini diminum tepat waktu',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.grey,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Sempurna',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DATE HEADER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDateHeader(String title, String date, Color dotColor) {
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

  // ═══════════════════════════════════════════════════════════════
  // MEDICATION CARD
  // ═══════════════════════════════════════════════════════════════
  Widget _buildMedicationCard({
    required String name,
    required String dosage,
    required String time,
    required String instruction,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconContainer(icon),
          const SizedBox(width: 12),
          Expanded(child: _buildMedicationInfo(name, dosage, time, instruction)),
          const SizedBox(width: 8),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildMedicationInfo(String name, String dosage, String time, String instruction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            if (dosage.isNotEmpty) ...[
              const SizedBox(width: 4),
              _buildDosageBadge(dosage),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 11,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '$time • $instruction',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDosageBadge(String dosage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        dosage,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: const Text(
        'Diminum',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}