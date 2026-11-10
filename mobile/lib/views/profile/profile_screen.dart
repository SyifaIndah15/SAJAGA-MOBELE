import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_constant.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/reminder_tile.dart';
import '../widgets/history_item_card.dart';
import '../history/history_screen.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color pinkLogout = Color(0xFFFFD6D6);
  static const Color logoutRed = Color(0xFFFF5252);

  // Data profil dari Supabase.
  String _userName = 'Memuat profil...';
  bool _isLoadingProfile = true;
  bool _isSavingProfile = false;

  String get _userEmail =>
      Supabase.instance.client.auth.currentUser?.email ?? '';

  bool _obatReminder = true;
  bool _makanReminder = true;
  bool _suaraGetar = true;

  int _selectedHistoryTab = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Mengambil nama pengguna dari tabel users.
  Future<void> _loadProfile() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        _userName = 'Pengguna';
        _isLoadingProfile = false;
      });
      return;
    }

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
        _isLoadingProfile = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _userName = user.email?.split('@').first ?? 'Pengguna';
        _isLoadingProfile = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil gagal dimuat dari database.')),
      );

      debugPrint('Gagal memuat profil: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: _buildHeader(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(),
              const SizedBox(height: 14),
              _buildReminderSection(),
              const SizedBox(height: 14),
              _buildHistorySection(),
              const SizedBox(height: 14),
              _buildHelpSection(),
              const SizedBox(height: 16),
              _buildLogoutButton(),
              const SizedBox(height: 18),
              _buildFooter(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Header aplikasi.
  Widget _buildHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(
            8,
          ), // Diperbesar sedikit agar lebih proporsional
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.medical_services,
            color: AppColors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'SAJAGA',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans', // Memastikan font sesuai config
            fontWeight:
                FontWeight.w800, // Extra Bold agar terlihat seperti Logo
            color: AppColors.primary,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // Kartu profil pengguna.
  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.lightBlue,
                child: Text(
                  _getInitials(_userName),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _isLoadingProfile ? null : _showEditProfileDialog,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _userName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail.isNotEmpty ? _userEmail : 'Email tidak tersedia',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Pengaturan pengingat.
  Widget _buildReminderSection() {
    return ProfileSection(
      title: 'Pengaturan Pengingat',
      icon: Icons.notifications_active_outlined,
      child: Column(
        children: [
          ReminderTile(
            title: 'Pengingat Jadwal Obat',
            subtitle: 'Alarm tepat waktu sebelum & sesudah makan',
            value: _obatReminder,
            onChanged: (val) {
              setState(() => _obatReminder = val);
            },
          ),
          const SizedBox(height: 8),
          ReminderTile(
            title: 'Pengingat Jadwal Makan',
            subtitle: 'Pemberitahuan pola makan ramah lambung',
            value: _makanReminder,
            onChanged: (val) {
              setState(() => _makanReminder = val);
            },
          ),
          const SizedBox(height: 8),
          ReminderTile(
            title: 'Suara Keras & Getar',
            subtitle: 'Memastikan alarm terdengar jelas di saku',
            value: _suaraGetar,
            onChanged: (val) {
              setState(() => _suaraGetar = val);
            },
          ),
        ],
      ),
    );
  }

  // Bagian riwayat.
  Widget _buildHistorySection() {
    return ProfileSection(
      title: 'Riwayat Terpadu',
      icon: Icons.history,
      actionText: 'Lihat Semua',
      onActionTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
      },
      child: Column(
        children: [
          _buildHistoryTab(),
          const SizedBox(height: 12),
          ..._getHistoryItems(),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabItem(title: "Riwayat Obat", index: 0),
          _buildTabItem(title: "Riwayat Makan", index: 1),
        ],
      ),
    );
  }

  Widget _buildTabItem({required String title, required int index}) {
    final bool isSelected = _selectedHistoryTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedHistoryTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.grey.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Data riwayat contoh.
  List<Widget> _getHistoryItems() {
    if (_selectedHistoryTab == 0) {
      return [
        HistoryItemCard(
          icon: Icons.medication,
          title: 'Paracetamol',
          subtitle: 'Hari ini ΓÇó 08:05 WIB',
          status: 'Diminum',
          isSuccess: true,
        ),
        const SizedBox(height: 8),
        HistoryItemCard(
          icon: Icons.medication,
          title: 'Vitamin C 500mg',
          subtitle: 'Kemarin ΓÇó 20:00 WIB',
          status: 'Diminum',
          isSuccess: true,
        ),
      ];
    }

    return [
      HistoryItemCard(
        icon: Icons.wb_sunny,
        title: 'Sarapan Pagi',
        subtitle: 'Hari ini ΓÇó 07:15 WIB',
        status: 'Selesai',
        isSuccess: true,
      ),
      const SizedBox(height: 8),
      HistoryItemCard(
        icon: Icons.wb_sunny,
        title: 'Makan Siang',
        subtitle: 'Hari ini ΓÇó 12:30 WIB',
        status: 'Selesai',
        isSuccess: true,
      ),
    ];
  }

  // Bantuan dan dukungan.
  Widget _buildHelpSection() {
    return ProfileSection(
      title: 'Bantuan & Dukungan',
      child: Column(
        children: [
          ProfileMenuTile(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan & FAQ',
            subtitle: 'Panduan penggunaan & pertanyaan',
          ),
          const SizedBox(height: 8),
          ProfileMenuTile(
            icon: Icons.phone_outlined,
            title: 'Hubungi Layanan Pengguna',
            subtitle: 'Kontak bantuan & tanggapan respon',
          ),
        ],
      ),
    );
  }

  // Tombol logout.
  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: pinkLogout,
          foregroundColor: logoutRed,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (dialogContext) => AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Keluar Akun',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              content: const Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: logoutRed,
                    foregroundColor: AppColors.white,
                  ),
                  onPressed: () async {
                    Navigator.pop(dialogContext);

                    try {
                      await Supabase.instance.client.auth.signOut();

                      if (!mounted) return;

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal logout: $e')),
                      );
                    }
                  },
                  child: const Text(
                    "Keluar",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, size: 16),
        label: const Text(
          "Keluar Akun",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Footer.
  Widget _buildFooter() {
    return const Center(
      child: Column(
        children: [
          Text(
            'SAJAGA App v1.2.0',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "Waktunya Dijaga, Sehatnya Dijaga",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Navigasi bawah.
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Beranda",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: "Profil",
        ),
      ],
    );
  }

  // Inisial avatar.
  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return '?';
    }

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return parts[0][0].toUpperCase();
  }

  // Dialog edit profil dan penyimpanan nama ke Supabase.
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    bool saving = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Edit Profil',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          content: TextField(
            controller: nameController,
            autofocus: true,
            maxLength: 100,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nama Lengkap',
              hintText: 'Contoh: Mas Bayu',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: saving
                  ? null
                  : () async {
                      final newName = nameController.text.trim();

                      if (newName.isEmpty) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama tidak boleh kosong.'),
                          ),
                        );
                        return;
                      }

                      final supabase = Supabase.instance.client;
                      final user = supabase.auth.currentUser;

                      if (user == null) {
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Silakan login kembali.'),
                          ),
                        );
                        return;
                      }

                      setDialogState(() {
                        saving = true;
                      });

                      try {
                        final result = await supabase
                            .from('users')
                            .update({
                              'name': newName,
                              'updated_at': DateTime.now()
                                  .toUtc()
                                  .toIso8601String(),
                            })
                            .eq('id', user.id)
                            .select('id, name')
                            .maybeSingle();

                        if (result == null) {
                          throw Exception(
                            'Profil tidak ditemukan atau akses update ditolak. '
                            'Pastikan baris users sudah ada untuk akun ini.',
                          );
                        }

                        if (!mounted) return;

                        setState(() {
                          _userName = result['name'] as String? ?? newName;
                        });

                        if (dialogContext.mounted) {
                          Navigator.pop(dialogContext);
                        }

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          const SnackBar(
                            content: Text('Nama profil berhasil diperbarui!'),
                          ),
                        );
                      } catch (e) {
                        setDialogState(() {
                          saving = false;
                        });

                        if (!mounted) return;

                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(content: Text('Gagal menyimpan nama: $e')),
                        );
                      }
                    },
              child: saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Text(
                      'Simpan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
            ),
          ],
        ),
      ),
    ).whenComplete(() {
      nameController.dispose();
    });
  }
}
