import 'package:flutter/material.dart';

/// Screen Detail Obat (Detail Medication Screen) - SAJAGA App
/// Lokasi file: lib/views/medication/detail_medication_screen.dart
class DetailMedicationScreen extends StatefulWidget {
  final String medicationName;
  final String dosage;
  final String form;

  const DetailMedicationScreen({
    super.key,
    this.medicationName = 'Paracetamol',
    this.dosage = '500 mg',
    this.form = 'Tablet',
  });

  @override
  State<DetailMedicationScreen> createState() => _DetailMedicationScreenState();
}

class _DetailMedicationScreenState extends State<DetailMedicationScreen> {
  // Status switch alarm pengingat
  bool _isAlarmActive = true;

  // Dialog konfirmasi hapus obat
  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626), size: 24),
              SizedBox(width: 8),
              Text(
                'Hapus Obat?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus jadwal obat "${widget.medicationName}"? Data jadwal dan riwayat obat ini akan dihapus.',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Obat "${widget.medicationName}" berhasil dihapus'),
                    backgroundColor: const Color(0xFFDC2626),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Ya, Hapus',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar
            _buildAppBar(),

            // 2. Scrollable Body Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Header Card
                    _buildHeroCard(),
                    const SizedBox(height: 24),

                    // Section: Jadwal Minum Hari Ini
                    const Text(
                      'Jadwal Minum Hari Ini',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleSection(),
                    const SizedBox(height: 24),

                    // Section: Petunjuk & Aturan Konsumsi
                    const Text(
                      'Petunjuk & Aturan Konsumsi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionCard(),
                    const SizedBox(height: 20),

                    // Section: Alarm Pengingat & Sisa Stok
                    _buildAlarmAndStockCard(),
                    const SizedBox(height: 32),

                    // Tombol Hapus Obat Ini (Sendirian sesuai instruksi user)
                    _buildDeleteButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// App Bar: Tombol Kembali, Judul "Detail Obat", Icon Trash, Avatar Profil
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF334155),
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 14),
              const Text(
                'Detail Obat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _showDeleteConfirmationDialog,
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFF64748B),
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 14),
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF0288D1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Hero Card Header: Icon Obat, Badge "Jadwal Aktif Hari Ini", Nama Obat, Dosis & Bentuk
  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2FE).withOpacity(0.35),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.medication_rounded,
                    color: Color(0xFF0288D1),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 13,
                            color: Color(0xFF0288D1),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Jadwal Aktif Hari Ini',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.medicationName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.dosage} • ${widget.form}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Bagian Jadwal Minum Hari Ini (3 Kartu: Pagi, Siang, Malam)
  Widget _buildScheduleSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildScheduleItemCard(
            icon: Icons.check,
            iconBgColor: const Color(0xFFBAE6FD),
            iconColor: const Color(0xFF0288D1),
            time: '08.00 WIB',
            period: '(Pagi)',
            subtitle: 'Dosis 1 • 1 tablet (500mg)',
            badgeText: 'Selesai 08.05',
            badgeBgColor: const Color(0xFFE0F2FE),
            badgeTextColor: const Color(0xFF0288D1),
            cardBgColor: const Color(0xFFF8FAFC),
          ),
          const SizedBox(height: 12),
          _buildScheduleItemCard(
            icon: Icons.notifications_active_outlined,
            iconBgColor: const Color(0xFFBAE6FD),
            iconColor: const Color(0xFF0288D1),
            time: '14.00 WIB',
            period: '(Siang)',
            subtitle: 'Dosis 2 • 1 tablet\n(500mg)',
            badgeText: 'Dalam 2 jam',
            badgeBgColor: const Color(0xFF0288D1),
            badgeTextColor: Colors.white,
            badgeIcon: Icons.timer_outlined,
            cardBgColor: const Color(0xFFF0F9FF),
            borderColor: const Color(0xFFBAE6FD),
          ),
          const SizedBox(height: 12),
          _buildScheduleItemCard(
            icon: Icons.nightlight_round,
            iconBgColor: const Color(0xFFF1F5F9),
            iconColor: const Color(0xFF64748B),
            time: '20.00 WIB',
            period: '(Malam)',
            subtitle: 'Dosis 3 • 1 tablet (500mg)',
            badgeText: 'Malam Ini',
            badgeBgColor: const Color(0xFFF1F5F9),
            badgeTextColor: const Color(0xFF64748B),
            cardBgColor: const Color(0xFFF8FAFC),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItemCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String time,
    required String period,
    required String subtitle,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required Color cardBgColor,
    Color? borderColor,
    IconData? badgeIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor ?? const Color(0xFFE2E8F0),
          width: borderColor != null ? 1.2 : 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      period,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badgeIcon != null) ...[
                  Icon(badgeIcon, size: 12, color: badgeTextColor),
                  const SizedBox(width: 4),
                ],
                Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: badgeTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Bagian Petunjuk & Aturan Konsumsi (Sesudah Makan)
  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: Color(0xFF0288D1),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sesudah Makan (Perut Terisi)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Minum 15–30 menit setelah sarapan atau makan siang untuk menjaga kenyamanan lambung.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      height: 1.4,
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

  /// Bagian Alarm Pengingat & Sisa Stok
  Widget _buildAlarmAndStockCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F9FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.alarm_rounded,
                      color: Color(0xFF0288D1),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Alarm Pengingat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Switch(
                value: _isAlarmActive,
                onChanged: (val) {
                  setState(() => _isAlarmActive = val);
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0288D1),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(
                      Icons.edit_calendar_outlined,
                      color: Color(0xFF0288D1),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Ubah Jadwal & Waktu Alarm',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Sisa 12 Tablet',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tombol Hapus Obat Ini (Sendirian tanpa tombol tandai dosis sesuai permintaan)
  Widget _buildDeleteButton() {
    return Center(
      child: TextButton.icon(
        onPressed: _showDeleteConfirmationDialog,
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: Color(0xFFDC2626),
          size: 20,
        ),
        label: const Text(
          'Hapus Obat Ini',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFFDC2626),
          ),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
