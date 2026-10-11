import 'package:flutter/material.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/reminder_tile.dart';
import '../widgets/history_item_card.dart';
import '../history/meal_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Konstanta Warna
  static const Color primaryBlue = Color(0xff008ACB);
  static const Color lightBlue = Color(0xffEEF9FF);
  static const Color pinkLogout = Color(0xffffd6d6);

  // State Variables untuk Data Profil
  String _userName = 'Bayu Cahyo';
  String _userEmail = 'bayu.cahyo@email.com';

  // State Variables untuk Switch Pengingat
  bool _obatReminder = true;
  bool _makanReminder = true;
  bool _suaraGetar = true;

  // State Variable untuk Tab Riwayat
  int _selectedHistoryTab = 0; // 0 = Obat, 1 = Makan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 15),
              _buildProfileCard(), // Sudah termasuk tombol edit
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

  // ==================== WIDGET BUILDERS ====================

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: primaryBlue,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.medical_services, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        const Text(
          "SAJAGA",
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // Stack untuk menumpuk tombol edit di atas avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: const Color(0xffDFF3FF),
                child: Text(
                  _getInitials(_userName), // Inisial otomatis
                  style: const TextStyle(
                    color: primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              // Tombol Edit di pojok kanan bawah avatar
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showEditProfileDialog,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _userName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            _userEmail,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderSection() {
    return ProfileSection(
      title: "Pengaturan Pengingat",
      child: Column(
        children: [
          ReminderTile(
            title: "Pengingat Jadwal Obat",
            subtitle: "Alarm tepat waktu sebelum & sesudah makan",
            value: _obatReminder,
            onChanged: (val) => setState(() => _obatReminder = val),
          ),
          const SizedBox(height: 8),
          ReminderTile(
            title: "Pengingat Jadwal Makan",
            subtitle: "Pemberitahuan pola makan ramah lambung",
            value: _makanReminder,
            onChanged: (val) => setState(() => _makanReminder = val),
          ),
          const SizedBox(height: 8),
          ReminderTile(
            title: "Suara Keras & Getar",
            subtitle: "Memastikan alarm terdengar jelas di saku",
            value: _suaraGetar,
            onChanged: (val) => setState(() => _suaraGetar = val),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return ProfileSection(
      title: "Riwayat Terpadu",
      actionText: "Lihat Semua",
      onActionTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MealHistoryScreen()),
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
        color: const Color(0xffF2F8FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedHistoryTab = 0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedHistoryTab == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedHistoryTab == 0
                      ? [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Center(
                  child: Text(
                    "Riwayat Obat",
                    style: TextStyle(
                      color: _selectedHistoryTab == 0 ? primaryBlue : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: _selectedHistoryTab == 0 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedHistoryTab = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: _selectedHistoryTab == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedHistoryTab == 1
                      ? [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Center(
                  child: Text(
                    "Riwayat Makan",
                    style: TextStyle(
                      color: _selectedHistoryTab == 1 ? primaryBlue : Colors.grey[600],
                      fontSize: 12,
                      fontWeight: _selectedHistoryTab == 1 ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _getHistoryItems() {
    if (_selectedHistoryTab == 0) {
      return [
        HistoryItemCard(icon: Icons.medication, title: "Paracetamol", subtitle: "Hari ini • 08:05 WIB", status: "Diminum", isSuccess: true),
        const SizedBox(height: 8),
        HistoryItemCard(icon: Icons.medication, title: "Vitamin C 500mg", subtitle: "Kemarin • 20:00 WIB", status: "Diminum", isSuccess: true),
      ];
    } else {
      return [
        HistoryItemCard(icon: Icons.wb_sunny, title: "Sarapan Pagi", subtitle: "Hari ini • 07:15 WIB", status: "Selesai", isSuccess: true),
        const SizedBox(height: 8),
        HistoryItemCard(icon: Icons.wb_sunny, title: "Makan Siang", subtitle: "Hari ini • 12:30 WIB", status: "Selesai", isSuccess: true),
      ];
    }
  }

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

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: pinkLogout,
          foregroundColor: Colors.redAccent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.bold)),
              content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Tambahkan logika logout ke halaman login di sini
                  },
                  child: const Text("Keluar"),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, size: 16),
        label: const Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildFooter() {
    return const Center(
      child: Column(
        children: [
          Text("SAJAGA App v1.2.0", style: TextStyle(fontSize: 10, color: Colors.grey)),
          SizedBox(height: 2),
          Text("Waktunya Dijaga, Sehatnya Dijaga", style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 1,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }

  // ==================== LOGIC HELPERS ====================

  /// Mengambil 2 huruf pertama dari nama untuk inisial avatar
  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  /// Menampilkan dialog popup untuk edit nama dan email
  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Edit Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              setState(() {
                _userName = nameController.text.trim().isEmpty ? _userName : nameController.text.trim();
                _userEmail = emailController.text.trim().isEmpty ? _userEmail : emailController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}