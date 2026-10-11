import 'package:flutter/material.dart';

/// Screen Riwayat Makan (Meal History Screen) - SAJAGA App
/// Lokasi file: lib/views/history/meal_history_screen.dart
class MealHistoryScreen extends StatefulWidget {
  const MealHistoryScreen({super.key});

  @override
  State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  // Default ke tab Makanan (index 1) karena ini halaman khusus makanan
  int _selectedTabIndex = 1; 

  // Data Model untuk Riwayat Makan Hari Ini
  final List<MealHistoryEntry> _todayMeals = const [
    MealHistoryEntry(
      name: 'Sarapan Pagi',
      time: '07.15 WIB',
      note: 'Tepat Waktu',
      status: 'Selesai',
      iconType: MealIconType.pagi,
    ),
    MealHistoryEntry(
      name: 'Makan Siang',
      time: '12.30 WIB',
      note: 'Tepat Waktu',
      status: 'Selesai',
      iconType: MealIconType.siang,
    ),
    MealHistoryEntry(
      name: 'Makan Malam',
      time: '19.10 WIB',
      note: 'Tepat Waktu',
      status: 'Selesai',
      iconType: MealIconType.malam,
    ),
  ];

  // Data Model untuk Riwayat Makan Kemarin
  final List<MealHistoryEntry> _yesterdayMeals = const [
    MealHistoryEntry(
      name: 'Sarapan Pagi',
      time: '07.20 WIB',
      note: 'Tepat Waktu',
      status: 'Selesai',
      iconType: MealIconType.pagi,
    ),
    MealHistoryEntry(
      name: 'Makan Siang',
      time: '12.45 WIB',
      note: 'Tepat Waktu',
      status: 'Selesai',
      iconType: MealIconType.siang,
    ),
    MealHistoryEntry(
      name: 'Makan Malam',
      time: '19.15 WIB',
      note: 'Tepat Waktu',
      status: 'Selesai',
      iconType: MealIconType.malam,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD), // Sama dengan temanmu agar konsisten
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
                    // Tampilkan konten berdasarkan tab yang dipilih
                    if (_selectedTabIndex == 1) ...[
                      _buildDateSectionHeader(
                        dotColor: const Color(0xFF0288D1),
                        dayLabel: 'Hari Ini',
                        dateLabel: 'Rabu, 24 Mei',
                      ),
                      const SizedBox(height: 10),
                      ..._todayMeals.map(
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
                      ..._yesterdayMeals.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: _buildHistoryCard(item),
                        ),
                      ),
                    ] else ...[
                      // Placeholder untuk tab Obat (karena ini tugas temanmu)
                      _buildObatPlaceholder(),
                    ],
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

  // ============ WIDGET-WIDGET PEMBANTU (Sama persis strukturnya dengan punya temanmu) ============

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
                  child: const Text(
                    'Obat',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Simplified for readability
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
                  child: const Text(
                    'Makanan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
            Text(
              dayLabel, 
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))
            ),
          ],
        ),
        Text(
          dateLabel, 
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B))
        ),
      ],
    );
  }

  Widget _buildHistoryCard(MealHistoryEntry item) {
    // Tentukan icon berdasarkan jenis waktu makan
    IconData icon = (item.iconType == MealIconType.pagi || item.iconType == MealIconType.siang)
        ? Icons.wb_sunny_rounded
        : Icons.nightlight_round;

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
                  Text(
                    item.name, 
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, size: 13, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        item.time, 
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '• ${item.note}', 
                        style: const TextStyle(fontSize: 11, color: Color(0xFF0288D1), fontWeight: FontWeight.w500)
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F9F0), 
              borderRadius: BorderRadius.circular(16)
            ),
            child: Text(
              item.status, 
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF10B981))
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder khusus agar tidak bentrok dengan tugas teman
  Widget _buildObatPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0288D1).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.medical_services_rounded, color: Color(0xFF0288D1), size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              'Riwayat Obat',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 8),
            Text(
              'Data riwayat obat dikelola di modul terpisah.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// ============ DATA MODEL (Sama konsepnya dengan temanmu) ============

enum MealIconType { pagi, siang, malam }

class MealHistoryEntry {
  final String name;
  final String time;
  final String note;
  final String status;
  final MealIconType iconType;

  const MealHistoryEntry({
    required this.name,
    required this.time,
    required this.note,
    required this.status,
    required this.iconType,
  });
}