import 'package:flutter/material.dart';
import '../../config/app_constant.dart';
import '../widgets/medication_card.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  // Data dummy untuk testing
  final List<MedicationItem> _medications = [
    MedicationItem(
      id: '1',
      name: 'Paracetamol',
      dosage: '500mg • 1 tablet sesudah makan',
      scheduledTime: DateTime.now().subtract(const Duration(hours: 2)), // 2 jam lalu (missed)
      status: MedicationStatus.missed,
    ),
    MedicationItem(
      id: '2',
      name: 'Vitamin C',
      dosage: '1 kapsul sebelum istirahat',
      scheduledTime: DateTime.now().add(const Duration(hours: 2)), // 2 jam lagi (upcoming)
      status: MedicationStatus.upcoming,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTopBar(),
                const SizedBox(height: 24),
                _buildGreetingSection(),
                const SizedBox(height: 20),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildTodayMedicationSection(),
                const SizedBox(height: 24),
                _buildRecommendationCard(),
                const SizedBox(height: 24),
                _buildTodayActivitySection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Top Bar ───────────────────────────────────────────────
  Widget _buildTopBar() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.home, color: AppColors.primary, size: 24),
            SizedBox(width: 8),
            Text('SAJAGA',
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary)),
          ],
        ),
        Icon(Icons.notifications_outlined, color: AppColors.navy, size: 26),
      ],
    );
  }

  // ─── Greeting ──────────────────────────────────────────────
  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Halo, Bayu 👋',
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy)),
            SizedBox(height: 4),
            Text('Waktunya diingat, Sehatnya dijaga!',
                style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, color: AppColors.grey)),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.lightBlue,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondary, width: 2),
          ),
          child: const Icon(Icons.person, color: AppColors.primary, size: 24),
        ),
      ],
    );
  }

  // ─── Quick Actions ─────────────────────────────────────────
  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.medication_outlined,
            iconColor: AppColors.primary,
            iconBg: AppColors.lightBlue,
            title: 'Tambah Obat',
            subtitle: 'Jadwal baru',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.restaurant_menu,
            iconColor: const Color(0xFFFF9800),
            iconBg: const Color(0xFFFFF3E0),
            title: 'Jadwal Makan',
            subtitle: 'Atur menu',
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy)),
                Text(subtitle,
                    style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Today's Medication ────────────────────────────────────
  Widget _buildTodayMedicationSection() {
    // Hitung statistik
    int takenCount = _medications.where((m) => m.status == MedicationStatus.taken).length;
    int lateCount = _medications.where((m) => m.status == MedicationStatus.late).length;
    int missedCount = _medications.where((m) => m.status == MedicationStatus.missed).length;
    int upcomingCount = _medications.where((m) => m.status == MedicationStatus.upcoming).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.link, color: AppColors.primary, size: 18),
                SizedBox(width: 6),
                Text('Obat Hari Ini',
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy)),
              ],
            ),
            _buildSummaryBadge(takenCount, lateCount, missedCount, upcomingCount),
          ],
        ),
        const SizedBox(height: 12),
        ..._medications.map((med) => _buildMedicationCard(med)),
      ],
    );
  }

Widget _buildSummaryBadge(int taken, int late, int missed, int upcoming) {
  String text = '';
  Color bgColor = AppColors.lightBlue;
  Color textColor = AppColors.primary;

  if (missed > 0 || late > 0) {
    // Format: "1 Terlewat + 1 Jam + 2 Diminum"
    List<String> parts = [];
    if (missed > 0) parts.add('$missed Terlewat');
    if (late > 0) parts.add('$late Jam');
    if (taken > 0) parts.add('$taken Diminum');
    
    text = parts.join(' + ');
    bgColor = const Color(0xFFFFEBEE);
    textColor = const Color(0xFFE53935);
  } else {
    text = '$taken dari ${_medications.length} diminum';
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text,
        style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor)),
  );
}

  Widget _buildMedicationCard(MedicationItem med) {
    int? lateMinutes;
    if (med.status == MedicationStatus.late) {
      lateMinutes = DateTime.now().difference(med.scheduledTime).inMinutes;
    }

    return MedicationCard(
      time: '${med.scheduledTime.hour.toString().padLeft(2, '0')}.${med.scheduledTime.minute.toString().padLeft(2, '0')}',
      timeLabel: _getTimeLabel(med.scheduledTime),
      medicationName: med.name,
      dosage: med.dosage,
      status: med.status,
      lateMinutes: lateMinutes,
      onTapCheck: () => _handleCheckMedication(med),
      onTapMinumSekarang: () => _handleMinumSekarang(med),
      onTapAturJadwal: () => _handleAturJadwal(med),
      onTapAturUlang: () => _handleAturUlang(med),
    );
  }

  String _getTimeLabel(DateTime time) {
    if (time.hour >= 5 && time.hour < 12) return 'Pagi';
    if (time.hour >= 12 && time.hour < 15) return 'Siang';
    if (time.hour >= 15 && time.hour < 18) return 'Sore';
    return 'Malam';
  }

  void _handleCheckMedication(MedicationItem med) {
    setState(() {
      med.status = MedicationStatus.taken;
    });
    // TODO: Panggil fungsi database untuk simpan
    print('Obat ${med.name} ditandai sudah diminum');
  }

  void _handleMinumSekarang(MedicationItem med) {
    setState(() {
      med.status = MedicationStatus.taken;
    });
    // TODO: Panggil fungsi database untuk simpan
    print('Obat ${med.name} diminum sekarang (terlambat)');
  }

  void _handleAturJadwal(MedicationItem med) {
    // TODO: Navigasi ke halaman edit jadwal
    print('Navigasi ke edit jadwal untuk ${med.name}');
  }

  void _handleAturUlang(MedicationItem med) {
    // TODO: Navigasi ke halaman atur ulang jadwal
    print('Atur ulang jadwal untuk ${med.name}');
  }

  // ─── Recommendation Card ───────────────────────────────────
  Widget _buildRecommendationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Rekomendasi\nMakanan Sehat',
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    SizedBox(height: 8),
                    Text(
                      'Temukan santapan yang ramah lambung dan aman dari alergi tubuhmu.',
                      style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.eco, color: Colors.white, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _ChipWidget(label: 'Cek Alergi', icon: Icons.health_and_safety),
              SizedBox(width: 8),
              _ChipWidget(label: 'Cek Pantangan', icon: Icons.warning_amber_rounded),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lihat Rekomendasi',
                        style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: AppColors.primary, size: 16),
                  ],
                ),
              ),
              const Text('8 Menu Tersedia',
                  style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Today's Activity ──────────────────────────────────────
  Widget _buildTodayActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Icon(Icons.list_alt, color: AppColors.primary, size: 18),
                SizedBox(width: 6),
                Text('Aktivitas Hari Ini',
                    style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy)),
              ],
            ),
            const Text('Rabu, 24 Mei',
                style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, color: AppColors.grey)),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jadwal Makan',
                  style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy)),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _MealItemWidget(title: 'Sarapan', subtitle: 'Selesai (07:15)', isDone: true)),
                  SizedBox(width: 8),
                  Expanded(child: _MealItemWidget(title: 'Makan Siang', subtitle: 'Selesai (12.30)', isDone: true)),
                  SizedBox(width: 8),
                  Expanded(child: _MealItemWidget(title: 'Makan Malam', subtitle: '19.00 Nanti', isDone: false, isUpcoming: true)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Bottom Navigation ────────────────────────────────────
  Widget _buildBottomNav() {
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
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedLabelStyle: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA MODEL
// ═══════════════════════════════════════════════════════════════

class MedicationItem {
  final String id;
  final String name;
  final String dosage;
  final DateTime scheduledTime;
  MedicationStatus status;

  MedicationItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.scheduledTime,
    required this.status,
  });
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

class _ChipWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ChipWidget({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: Colors.white)),
        ],
      ),
    );
  }
}

class _MealItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isUpcoming;

  const _MealItemWidget({
    required this.title,
    required this.subtitle,
    required this.isDone,
    this.isUpcoming = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDone ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isUpcoming ? AppColors.grey.withOpacity(0.3) : AppColors.primary,
            ),
          ),
          child: Icon(
            isDone ? Icons.check : Icons.access_time,
            color: isDone ? Colors.white : AppColors.grey,
            size: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(title,
            style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.navy),
            textAlign: TextAlign.center),
        const SizedBox(height: 2),
        Text(subtitle,
            style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10,
                color: isDone ? AppColors.primary : const Color(0xFFFF9800),
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
      ],
    );
  }
}