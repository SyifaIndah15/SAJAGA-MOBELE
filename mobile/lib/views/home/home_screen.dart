import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_constant.dart';
import '../../routes/app_routes.dart';
import '../medication/add_medication_screen.dart';
import '../../services/medication_service.dart';
import '../widgets/medication_card.dart';

const Color _pageBackground = Color(0xFFF4FAFD);
const Color _borderColor = Color(0xFFE5EEF5);
const Color _mutedText = Color(0xFF718096);
const Color _orange = Color(0xFFF59E0B);
const Color _orangeBackground = Color(0xFFFFF7ED);
const Color _iconGrey = Color(0xFF94A3B8);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Pengguna';

  final MedicationService _medicationService = MedicationService();
  List<Map<String, dynamic>> _medicationSchedules = [];
  bool _isLoadingMedications = true;
  String? _medicationError;
  Timer? _statusRefreshTimer;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadTodayMedications();

    // Perbarui status waktu secara berkala tanpa mengambil ulang data Supabase.
    _statusRefreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _medicationSchedules.isNotEmpty) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _statusRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTodayMedications() async {
    if (mounted) {
      setState(() {
        _isLoadingMedications = true;
        _medicationError = null;
      });
    }

    try {
      final schedules = await _medicationService.getTodaySchedules();

      if (!mounted) return;

      setState(() {
        _medicationSchedules = schedules;
        _isLoadingMedications = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil jadwal obat: $e');

      if (!mounted) return;

      setState(() {
        _medicationError = e.toString();
        _isLoadingMedications = false;
      });
    }
  }

  Future<void> _loadUserName() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    try {
      final profile = await supabase
          .from('users')
          .select('name')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      final databaseName = profile?['name'] as String?;
      final fallbackName = user.email?.split('@').first ?? 'Pengguna';

      setState(() {
        _userName = databaseName != null && databaseName.trim().isNotEmpty
            ? databaseName.trim()
            : fallbackName;
      });
    } catch (e) {
      debugPrint('Gagal mengambil nama pengguna: $e');
    }
  }

  void _showPrototypeMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildPinnedHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGreeting(),
                    const SizedBox(height: 17),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.medication_outlined,
                            title: 'Tambah Obat',
                            subtitle: 'Jadwal baru',
                            iconColor: AppColors.primary,
                            iconBackground: AppColors.lightBlue,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddMedicationScreen(),
                                ),
                              );

                              if (result == true && mounted) {
                                await _loadTodayMedications();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.restaurant,
                            title: 'Jadwal Makan',
                            subtitle: 'Atur menu',
                            iconColor: _orange,
                            iconBackground: _orangeBackground,
                            onTap: () => _showPrototypeMessage(
                              'Menu Jadwal Makan belum terhubung.',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SectionHeading(
                      title: 'Obat Hari Ini',
                      trailing: _isLoadingMedications
                          ? 'Memuat...'
                          : '${_medicationSchedules.length} Terjadwal',
                    ),
                    const SizedBox(height: 8),
                    _buildTodayMedicationContent(),
                    const SizedBox(height: 18),
                    _RecommendationCard(
                      onRecommendationTap: () => _showPrototypeMessage(
                        'Halaman rekomendasi makanan belum terhubung.',
                      ),
                      onAllergyTap: () => _showPrototypeMessage(
                        'Pemeriksaan alergi belum terhubung.',
                      ),
                      onRestrictionTap: () => _showPrototypeMessage(
                        'Pemeriksaan pantangan belum terhubung.',
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _SectionHeading(
                      title: 'Aktivitas Hari Ini',
                      trailing: 'Hari ini',
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 118,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _borderColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF1F5F9),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.event_note_outlined,
                              size: 17,
                              color: _iconGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Belum Ada Rutinitas Terjadwal',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _PrototypeBottomNavigation(
        selectedIndex: 0,
        onItemTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.profile);
          }
        },
      ),
    );
  }

  Widget _buildTodayMedicationContent() {
    if (_isLoadingMedications) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor),
        ),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_medicationError != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          children: [
            const Text(
              'Jadwal obat belum dapat dimuat.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loadTodayMedications,
              icon: const Icon(Icons.refresh, size: 17),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    if (_medicationSchedules.isEmpty) {
      return Container(
        width: double.infinity,
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Belum Ada Jadwal Obat Hari Ini',
          style: TextStyle(fontSize: 13, color: Color(0xFF334155)),
        ),
      );
    }

    return Column(
      children: _medicationSchedules.map((schedule) {
        return _buildMedicationCard(schedule);
      }).toList(),
    );
  }

  // Mengubah data jadwal dari MedicationService menjadi MedicationCard.
  Widget _buildMedicationCard(Map<String, dynamic> schedule) {
    final rawTime = schedule['schedule_time']?.toString() ?? '';
    final timeParts = rawTime.split(':');

    final hour = timeParts.isNotEmpty ? int.tryParse(timeParts[0]) ?? 0 : 0;
    final minute = timeParts.length > 1 ? int.tryParse(timeParts[1]) ?? 0 : 0;

    final now = DateTime.now();
    final scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

    final elapsedSinceSchedule = now.difference(scheduledTime);

    // Aturan waktu:
    // - Sebelum jadwal: upcoming.
    // - 00:00 sampai sebelum 05:00 setelah jadwal: ready.
    // - 05:00 sampai sebelum 60:00 setelah jadwal: late.
    // - 60:00 atau lebih setelah jadwal: missed.
    final MedicationStatus status;
    if (elapsedSinceSchedule.isNegative) {
      status = MedicationStatus.upcoming;
    } else if (elapsedSinceSchedule < const Duration(minutes: 5)) {
      status = MedicationStatus.ready;
    } else if (elapsedSinceSchedule < const Duration(hours: 1)) {
      status = MedicationStatus.late;
    } else {
      status = MedicationStatus.missed;
    }

    final lateMinutes = elapsedSinceSchedule.isNegative
        ? 0
        : elapsedSinceSchedule.inMinutes;

    final String timeLabel;
    if (hour >= 5 && hour < 12) {
      timeLabel = 'Pagi';
    } else if (hour >= 12 && hour < 15) {
      timeLabel = 'Siang';
    } else if (hour >= 15 && hour < 18) {
      timeLabel = 'Sore';
    } else {
      timeLabel = 'Malam';
    }

    final medicationName = schedule['medication_name']?.toString() ?? 'Obat';
    final medicationDose = schedule['medication_dose']?.toString() ?? '';
    final mealInstruction = schedule['meal_instruction']?.toString() ?? '';

    final dosage = [
      medicationDose,
      if (mealInstruction.isNotEmpty) mealInstruction,
    ].where((value) => value.trim().isNotEmpty).join(' • ');

    return MedicationCard(
      time:
          '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}',
      timeLabel: timeLabel,
      medicationName: medicationName,
      dosage: dosage,
      status: status,
      lateMinutes: status == MedicationStatus.late ? lateMinutes : null,
      onTapCheck: () {
        _showPrototypeMessage(
          'Pencatatan obat diminum belum terhubung ke database.',
        );
      },
      onTapMinumSekarang: () {
        _showPrototypeMessage(
          'Pencatatan obat diminum belum terhubung ke database.',
        );
      },
      onTapAturJadwal: () {
        _showPrototypeMessage('Pengaturan ulang jadwal belum terhubung.');
      },
      onTapAturUlang: () {
        _showPrototypeMessage('Pengaturan ulang jadwal belum terhubung.');
      },
    );
  }

  Widget _buildPinnedHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAF3F8), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.secondary, AppColors.primary],
              ),
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.medical_services_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'SAJAGA',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.35,
            ),
          ),
          const Spacer(),
          Material(
            color: AppColors.lightBlue,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
              child: const SizedBox(
                width: 38,
                height: 38,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, $_userName 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Waktunya diingat, sehatnya dijaga!',
                style: TextStyle(fontSize: 10, color: _mutedText),
              ),
            ],
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: AppColors.lightBlue,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.health_and_safety_outlined,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBackground,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBackground;
  final VoidCallback onTap;

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: AnimatedScale(
        scale: _pressed ? 0.975 : (_hovered ? 1.015 : 1),
        duration: const Duration(milliseconds: 130),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            onHover: (value) => setState(() => _hovered = value),
            splashColor: AppColors.primary.withValues(alpha: 0.10),
            highlightColor: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(15),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 130),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(
                color: _hovered ? const Color(0xFFFCFEFF) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _hovered ? const Color(0xFFB8DDF0) : _borderColor,
                ),
                boxShadow: _hovered
                    ? const [
                        BoxShadow(
                          color: Color(0x120284C7),
                          blurRadius: 9,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : const [],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.iconBackground,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(widget.icon, color: widget.iconColor, size: 17),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: _mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
        ),
        Text(trailing, style: const TextStyle(fontSize: 10, color: _mutedText)),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.onRecommendationTap,
    required this.onAllergyTap,
    required this.onRestrictionTap,
  });

  final VoidCallback onRecommendationTap;
  final VoidCallback onAllergyTap;
  final VoidCallback onRestrictionTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(23, 22, 22, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0284C7), Color(0xFF38BDF8)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x240284C7),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Rekomendasi\nMakanan Sehat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    height: 1.28,
                    letterSpacing: -0.25,
                  ),
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.28),
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.eco_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Temukan santapan yang ramah\n'
            'lambung dan aman dari alergi\n'
            'tubuhmu.',
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.55),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RecommendationTag(
                icon: Icons.shield_outlined,
                label: 'Cek Alergi',
                onTap: onAllergyTap,
              ),
              _RecommendationTag(
                icon: Icons.do_not_disturb_alt_outlined,
                label: 'Cek Pantangan',
                onTap: onRestrictionTap,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: _RecommendationButton(onTap: onRecommendationTap),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  '8 Menu Tersedia',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecommendationTag extends StatefulWidget {
  const _RecommendationTag({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_RecommendationTag> createState() => _RecommendationTagState();
}

class _RecommendationTagState extends State<_RecommendationTag> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: _hovered
            ? Colors.white.withValues(alpha: 0.30)
            : Colors.white.withValues(alpha: 0.19),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: widget.onTap,
          onHover: (value) => setState(() => _hovered = value),
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withValues(alpha: 0.22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, size: 14, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecommendationButton extends StatefulWidget {
  const _RecommendationButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_RecommendationButton> createState() => _RecommendationButtonState();
}

class _RecommendationButtonState extends State<_RecommendationButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 120),
        child: Material(
          color: _hovered ? const Color(0xFFF0F9FF) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            onHover: (value) => setState(() => _hovered = value),
            borderRadius: BorderRadius.circular(30),
            splashColor: AppColors.primary.withValues(alpha: 0.12),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 17, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Lihat Rekomendasi',
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Color(0xFF0369A1),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward, color: Color(0xFF0369A1), size: 17),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrototypeBottomNavigation extends StatelessWidget {
  const _PrototypeBottomNavigation({
    required this.selectedIndex,
    required this.onItemTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAF0F5), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PrototypeNavItem(
              label: 'Beranda',
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              selected: selectedIndex == 0,
              onTap: () => onItemTap(0),
            ),
          ),
          Expanded(
            child: _PrototypeNavItem(
              label: 'Profil',
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              selected: selectedIndex == 1,
              onTap: () => onItemTap(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrototypeNavItem extends StatefulWidget {
  const _PrototypeNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_PrototypeNavItem> createState() => _PrototypeNavItemState();
}

class _PrototypeNavItemState extends State<_PrototypeNavItem> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final Color itemColor = widget.selected
        ? AppColors.primary
        : const Color(0xFF94A3B8);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
            width: _hovered ? 104 : 0,
            height: _hovered ? 60 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EAEC)
                  .withValues(alpha: _hovered ? 1 : 0),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: (value) => setState(() => _pressed = value),
              borderRadius: BorderRadius.circular(40),
              child: SizedBox(
                width: double.infinity,
                height: 66,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: _pressed ? 0.88 : (_hovered ? 1.08 : 1),
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        widget.selected ? widget.activeIcon : widget.icon,
                        color: itemColor,
                        size: 21,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: itemColor,
                        fontSize: 11,
                        fontWeight: widget.selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
