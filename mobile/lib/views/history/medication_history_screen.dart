import 'package:flutter/material.dart';

/// Screen Riwayat Obat (Medication History Screen) - SAJAGA App
/// Lokasi file: lib/views/history/medication_history_screen.dart
class MedicationHistoryScreen extends StatefulWidget {
  const MedicationHistoryScreen({super.key});

  @override
  State<MedicationHistoryScreen> createState() => _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState extends State<MedicationHistoryScreen> {
  int _selectedTabIndex = 0; // 0: 'Obat', 1: 'Makanan'

  final List<MedicationHistoryEntry> _todayMedications = const [
    MedicationHistoryEntry(
      name: 'Antasida Doen',
      time: '07.30 WIB',
      note: 'Sebelum Makan',
      status: 'Diminum',
      iconType: HistoryIconType.bottle,
    ),
    MedicationHistoryEntry(
      name: 'Paracetamol 500mg',
      time: '08.05 WIB',
      note: 'Tepat Waktu',
      status: 'Diminum',
      iconType: HistoryIconType.capsule,
    ),
    MedicationHistoryEntry(
      name: 'Amoxicillin 500mg',
      time: '13.00 WIB',
      note: 'Tepat Waktu',
      status: 'Diminum',
      iconType: HistoryIconType.bottle,
    ),
    MedicationHistoryEntry(
      name: 'Vitamin B Kompleks',
      time: '19.30 WIB',
      note: 'Tepat Waktu',
      status: 'Diminum',
      iconType: HistoryIconType.capsule,
    ),
  ];

  final List<MedicationHistoryEntry> _yesterdayMedications = const [
    MedicationHistoryEntry(
      name: 'Paracetamol 500mg',
      time: '08.00 WIB',
      note: 'Tepat Waktu',
      status: 'Diminum',
      iconType: HistoryIconType.bottle,
    ),
    MedicationHistoryEntry(
      name: 'Amoxicillin 500mg',
      time: '12.45 WIB',
      note: 'Tepat Waktu',
      status: 'Diminum',
      iconType: HistoryIconType.bottle,
    ),
    MedicationHistoryEntry(
      name: 'Vitamin C 500mg',
      time: '20.00 WIB',
      note: 'Tepat Waktu',
      status: 'Diminum',
      iconType: HistoryIconType.capsule,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSegmentedTab(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateSectionHeader(
                      dotColor: const Color(0xFF0288D1),
                      dayLabel: 'Hari Ini',
                      dateLabel: 'Rabu, 24 Mei',
                    ),
                    const SizedBox(height: 10),
                    ..._todayMedications.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildHistoryCard(item),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDateSectionHeader(
                      dotColor: const Color(0xFF94A3B8),
                      dayLabel: 'Kemarin',
                      dateLabel: 'Selasa, 23 Mei',
                    ),
                    const SizedBox(height: 10),
                    ..._yesterdayMedications.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: _buildHistoryCard(item),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B), size: 24),
          ),
          const SizedBox(width: 8),
          const Text(
            'Riwayat Aktivitas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 46,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0).withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedTabIndex = 0),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 0 ? const Color(0xFF0288D1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Obat',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _selectedTabIndex == 0 ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedTabIndex = 1),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 1 ? const Color(0xFF0288D1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Makanan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: _selectedTabIndex == 1 ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSectionHeader({
    required Color dotColor,
    required String dayLabel,
    required String dateLabel,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(radius: 3, backgroundColor: dotColor),
            const SizedBox(width: 8),
            Text(dayLabel, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          ],
        ),
        Text(dateLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildHistoryCard(MedicationHistoryEntry item) {
    IconData icon = item.iconType == HistoryIconType.bottle
        ? Icons.medical_services_outlined
        : Icons.medication_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.025), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: Color(0xFFF0F9FF), shape: BoxShape.circle),
                child: Icon(icon, color: const Color(0xFF0288D1), size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(item.time, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                      const SizedBox(width: 4),
                      Text('• ${item.note}', style: const TextStyle(fontSize: 11, color: Color(0xFF0288D1), fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFE6F9F0), borderRadius: BorderRadius.circular(16)),
            child: Text(item.status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF10B981))),
          ),
        ],
      ),
    );
  }
}

enum HistoryIconType { bottle, capsule }

class MedicationHistoryEntry {
  final String name;
  final String time;
  final String note;
  final String status;
  final HistoryIconType iconType;

  const MedicationHistoryEntry({
    required this.name,
    required this.time,
    required this.note,
    required this.status,
    required this.iconType,
  });
}
