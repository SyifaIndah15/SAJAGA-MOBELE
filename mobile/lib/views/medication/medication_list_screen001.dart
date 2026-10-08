import 'package:flutter/material.dart';

/// File: lib/views/medication/medication_list_screen.dart
/// Screen utama untuk daftar obat (Medication List Screen) - SAJAGA App
class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  int _currentBottomNavIndex = 0;

  // Data jadwal obat hari ini
  final List<MedicationScheduleItem> _medicationList = [
    MedicationScheduleItem(
      id: '1',
      time: '08.00 Pagi',
      name: 'Paracetamol',
      dose: '500mg • 1 tablet sesudah makan',
      status: MedicationStatus.taken,
      timeType: TimeType.morning,
    ),
    MedicationScheduleItem(
      id: '2',
      time: '14.00 Siang',
      name: 'Paracetamol',
      dose: '500mg • 1 tablet sesudah makan',
      status: MedicationStatus.timeToTake,
      timeType: TimeType.afternoon,
    ),
    MedicationScheduleItem(
      id: '3',
      time: '20.00 Malam',
      name: 'Vitamin C',
      dose: '1 kapsul sebelum istirahat',
      status: MedicationStatus.upcoming,
      timeType: TimeType.night,
    ),
  ];

  int get _takenCount =>
      _medicationList.where((item) => item.status == MedicationStatus.taken).length;

  void _markAsCompleted(String id) {
    setState(() {
      final index = _medicationList.indexWhere((item) => item.id == id);
      if (index != -1) {
        _medicationList[index] = _medicationList[index].copyWith(
          status: MedicationStatus.taken,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Obat berhasil ditandai telah diminum!'),
        backgroundColor: Color(0xFF0288D1),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar: Logo SAJAGA & Notification
              _buildTopBar(),
              const SizedBox(height: 20),

              // 2. Greeting & User Profile Section
              _buildGreetingSection(),
              const SizedBox(height: 20),

              // 3. Quick Action Buttons (Tambah Obat & Jadwal Makan)
              _buildQuickActionButtons(),
              const SizedBox(height: 24),

              // 4. Section: Obat Hari Ini Header
              _buildMedicationSectionHeader(),
              const SizedBox(height: 14),

              // 5. Medication Cards List
              ..._medicationList.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildMedicationCard(item),
                  )),
              const SizedBox(height: 12),

              // 6. Healthy Food Recommendation Banner
              _buildFoodRecommendationBanner(),
              const SizedBox(height: 24),

              // 7. Section: Aktivitas Hari Ini
              _buildActivitySection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Top Bar: Logo Sajaga & Notifikasi
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF0288D1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SAJAGA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0288D1),
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF546E7A),
            size: 26,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  /// Greeting & Avatar Profil
  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Text(
                    'Halo, Bayu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text('👋', style: TextStyle(fontSize: 18)),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Waktunya diingat, Sehatnya dijaga!',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Color(0xFF0288D1),
            size: 24,
          ),
        ),
      ],
    );
  }

  /// Quick Action Buttons: Tambah Obat & Jadwal Makan
  Widget _buildQuickActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.medication_rounded,
            iconColor: const Color(0xFF0288D1),
            title: 'Tambah Obat',
            subtitle: 'Jadwal baru',
            onTap: () {
              // Navigator.pushNamed(context, '/add-medication');
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildActionCard(
            icon: Icons.restaurant_rounded,
            iconColor: const Color(0xFFE65100),
            title: 'Jadwal Makan',
            subtitle: 'Atur menu',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0288D1).withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE1F5FE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header Obat Hari Ini
  Widget _buildMedicationSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.link_rounded, color: Color(0xFF0288D1), size: 20),
            SizedBox(width: 8),
            Text(
              'Obat Hari Ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE1F5FE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$_takenCount dari ${_medicationList.length} diminum',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0288D1),
            ),
          ),
        ),
      ],
    );
  }

  /// Kartu Pengingat Obat
  Widget _buildMedicationCard(MedicationScheduleItem item) {
    IconData timeIcon;
    Color iconColor;

    switch (item.timeType) {
      case TimeType.morning:
        timeIcon = Icons.wb_sunny_outlined;
        iconColor = const Color(0xFF0288D1);
        break;
      case TimeType.afternoon:
        timeIcon = Icons.access_time_rounded;
        iconColor = const Color(0xFF0288D1);
        break;
      case TimeType.night:
        timeIcon = Icons.nightlight_round;
        iconColor = const Color(0xFFE65100);
        break;
    }

    final bool hasAccentBar = item.status != MedicationStatus.upcoming;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (hasAccentBar)
                Container(
                  width: 5,
                  color: const Color(0xFF0288D1),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFE0F2FE),
                            width: 1,
                          ),
                        ),
                        child: Icon(timeIcon, color: iconColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _buildStatusBadge(item.status),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.dose,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildActionWidget(item),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(MedicationStatus status) {
    switch (status) {
      case MedicationStatus.taken:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, size: 11, color: Color(0xFF0288D1)),
              SizedBox(width: 3),
              Text(
                'Diminum',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0288D1),
                ),
              ),
            ],
          ),
        );
      case MedicationStatus.timeToTake:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFBAE6FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Waktunya Minum',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0369A1),
            ),
          ),
        );
      case MedicationStatus.upcoming:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Akan Datang',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD97706),
            ),
          ),
        );
    }
  }

  Widget _buildActionWidget(MedicationScheduleItem item) {
    if (item.status == MedicationStatus.taken) {
      return Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFF0288D1),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      );
    } else if (item.status == MedicationStatus.timeToTake) {
      return ElevatedButton.icon(
        onPressed: () => _markAsCompleted(item.id),
        icon: const Icon(Icons.check, color: Colors.white, size: 14),
        label: const Text(
          'Selesai',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0288D1),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          minimumSize: const Size(0, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  /// Banner Rekomendasi Makanan Sehat
  Widget _buildFoodRecommendationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0288D1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Rekomendasi\nMakanan Sehat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Temukan santapan yang ramah lambung dan aman dari alergi tubuhmu.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildTag(icon: Icons.shield_outlined, text: 'Cek Alergi'),
              const SizedBox(width: 8),
              _buildTag(icon: Icons.do_not_disturb_alt_rounded, text: 'Cek Pantangan'),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0288D1),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Rekomendasi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
              const Text(
                '8 Menu Tersedia',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Bagian Aktivitas Hari Ini
  Widget _buildActivitySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, color: Color(0xFF0288D1), size: 18),
                SizedBox(width: 8),
                Text(
                  'Aktivitas Hari Ini',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
            Text(
              'Hari Ini',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F5F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.event_note_outlined,
                  color: Color(0xFF64748B),
                  size: 24,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Belum Ada Rutinitas Terjadwal',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(0, Icons.home_rounded, 'Beranda'),
              _buildBottomNavItem(1, Icons.person_outline_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentBottomNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentBottomNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE1F5FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isSelected ? const Color(0xFF0288D1) : const Color(0xFF94A3B8),
              size: 24,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF0288D1) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}

enum MedicationStatus { taken, timeToTake, upcoming }
enum TimeType { morning, afternoon, night }

class MedicationScheduleItem {
  final String id;
  final String time;
  final String name;
  final String dose;
  final MedicationStatus status;
  final TimeType timeType;

  MedicationScheduleItem({
    required this.id,
    required this.time,
    required this.name,
    required this.dose,
    required this.status,
    required this.timeType,
  });

  MedicationScheduleItem copyWith({
    String? id,
    String? time,
    String? name,
    String? dose,
    MedicationStatus? status,
    TimeType? timeType,
  }) {
    return MedicationScheduleItem(
      id: id ?? this.id,
      time: time ?? this.time,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      status: status ?? this.status,
      timeType: timeType ?? this.timeType,
    );
  }
}
