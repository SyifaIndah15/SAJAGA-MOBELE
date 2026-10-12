import 'package:flutter/material.dart';

import '../../config/app_constant.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/reminder_tile.dart';
import '../widgets/history_item_card.dart';
import '../history/history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //warna tambahan untuk logout (tidak masuk ke theme)
  static const Color pinkLogout = Color(0xFFFFD6D6);
  static const Color logoutRed = Color(0xFFFF5252);

  //data profil pengguna.
  String _userName = 'Syifa Indah';
  String _userEmail = 'indah15@gmail.com';

  //pengaturan pengingat.
  bool _obatReminder = true;
  bool _makanReminder = true;
  bool _suaraGetar = true;

  //tab riwayat: 0 = Obat, 1 = Makan.
  int _selectedHistoryTab = 0;

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

  //header
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.medical_services,
            color: AppColors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          "SAJAGA",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  //profile card
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

              //tombol edit profil.
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showEditProfileDialog,
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
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.navy,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            _userEmail,
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

  //reminder section
  Widget _buildReminderSection() {
    return ProfileSection(
      title: "Pengaturan Pengingat",
      icon: Icons.notifications_active_outlined,
      child: Column(
        children: [
          ReminderTile(
            title: "Pengingat Jadwal Obat",
            subtitle: "Alarm tepat waktu sebelum & sesudah makan",
            value: _obatReminder,
            onChanged: (val) {
              setState(() => _obatReminder = val);
            },
          ),

          const SizedBox(height: 8),

          ReminderTile(
            title: "Pengingat Jadwal Makan",
            subtitle: "Pemberitahuan pola makan ramah lambung",
            value: _makanReminder,
            onChanged: (val) {
              setState(() => _makanReminder = val);
            },
          ),

          const SizedBox(height: 8),

          ReminderTile(
            title: "Suara Keras & Getar",
            subtitle: "Memastikan alarm terdengar jelas di saku",
            value: _suaraGetar,
            onChanged: (val) {
              setState(() => _suaraGetar = val);
            },
          ),
        ],
      ),
    );
  }
  //histori section

  Widget _buildHistorySection() {
    return ProfileSection(
      title: "Riwayat Terpadu",
      icon: Icons.history,
      actionText: "Lihat Semua",
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

  //histori tab
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

  //histori item
  List<Widget> _getHistoryItems() {
    if (_selectedHistoryTab == 0) {
      return [
        HistoryItemCard(
          icon: Icons.medication,
          title: "Paracetamol",
          subtitle: "Hari ini • 08:05 WIB",
          status: "Diminum",
          isSuccess: true,
        ),

        const SizedBox(height: 8),

        HistoryItemCard(
          icon: Icons.medication,
          title: "Vitamin C 500mg",
          subtitle: "Kemarin • 20:00 WIB",
          status: "Diminum",
          isSuccess: true,
        ),
      ];
    } else {
      return [
        HistoryItemCard(
          icon: Icons.wb_sunny,
          title: "Sarapan Pagi",
          subtitle: "Hari ini • 07:15 WIB",
          status: "Selesai",
          isSuccess: true,
        ),

        const SizedBox(height: 8),
        HistoryItemCard(
          icon: Icons.wb_sunny,
          title: "Makan Siang",
          subtitle: "Hari ini • 12:30 WIB",
          status: "Selesai",
          isSuccess: true,
        ),
      ];
    }
  }

  //help section
  Widget _buildHelpSection() {
    return ProfileSection(
      title: "Bantuan & Dukungan",
      child: Column(
        children: [
          ProfileMenuTile(
            icon: Icons.help_outline,
            title: "Pusat Bantuan & FAQ",
            subtitle: "Panduan penggunaan & pertanyaan",
          ),

          const SizedBox(height: 8),

          ProfileMenuTile(
            icon: Icons.phone_outlined,
            title: "Hubungi Layanan Pengguna",
            subtitle: "Kontak bantuan & tanggapan respon",
          ),
        ],
      ),
    );
  }

  //logout button
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
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Keluar Akun",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              content: const Text(
                "Apakah Anda yakin ingin keluar dari aplikasi?",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Batal",
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
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO:
                    // Tambahkan navigasi logout
                    // ke halaman login.
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

  //footer
  Widget _buildFooter() {
    return const Center(
      child: Column(
        children: [
          Text(
            "SAJAGA App v1.2.0",
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

  //bottom navigation
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,

      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        }
      },

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

  //logic helpers
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

  //edit profil
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Profil',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.navy),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.navy,
              ),
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.navy,
              ),
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              setState(() {
                if (nameController.text.trim().isNotEmpty) {
                  _userName = nameController.text.trim();
                }

                if (emailController.text.trim().isNotEmpty) {
                  _userEmail = emailController.text.trim();
                }
              });
              Navigator.pop(context);
            },
            child: const Text(
              'Simpan',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      nameController.dispose();
      emailController.dispose();
    });
  }
}
