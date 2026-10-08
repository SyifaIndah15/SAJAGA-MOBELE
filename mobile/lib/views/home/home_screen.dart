import 'package:flutter/material.dart';

import '../../config/app_constant.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // HEADER

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,

                        decoration: BoxDecoration(
                          color: AppColors.primary,

                          borderRadius: BorderRadius.circular(7),
                        ),

                        child: const Icon(
                          Icons.health_and_safety,

                          color: Colors.white,

                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 8),

                      const Text(
                        "SAJAGA",

                        style: TextStyle(
                          fontSize: 14,

                          fontWeight: FontWeight.bold,

                          color: Color(0xff0284C7),
                        ),
                      ),
                    ],
                  ),

                  const Icon(
                    Icons.notifications_none,

                    size: 20,

                    color: Color(0xff64748B),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // GREETING
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        "Halo, Thesa 👋",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                          color: Color(0xff0F172A),
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Text(
                        "Waktunya diingat, sehatnya dijaga!",

                        style: TextStyle(
                          fontSize: 10,

                          color: Color(0xff64748B),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    width: 34,
                    height: 34,

                    decoration: const BoxDecoration(
                      color: Color(0xffE0F2FE),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.person_outline,

                      color: Color(0xff0284C7),

                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // MENU
              Row(
                children: [
                  Expanded(
                    child: _menuCard(
                      Icons.medication_outlined,

                      "Tambah Obat",

                      "Jadwal baru",

                      const Color(0xff0284C7),

                      const Color(0xffE0F2FE),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _menuCard(
                      Icons.restaurant_menu,

                      "Jadwal Makan",

                      "Atur menu",

                      const Color(0xffF59E0B),

                      const Color(0xffFFF7ED),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              _titleRow("Obat Hari Ini", "0 Terjadwal"),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,

                padding: const EdgeInsets.symmetric(vertical: 18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Column(
                  children: [
                    const Icon(
                      Icons.medication_outlined,

                      size: 32,

                      color: Color(0xff94A3B8),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Belum Ada Jadwal Obat Hari Ini",

                      style: TextStyle(fontSize: 11),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // REKOMENDASI
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff0284C7), Color(0xff38BDF8)],
                  ),

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          "Rekomendasi\nMakanan Sehat",

                          style: TextStyle(
                            color: Colors.white,

                            fontSize: 15,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(6),

                          decoration: const BoxDecoration(
                            color: Colors.white24,

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.restaurant,

                            color: Colors.white,

                            size: 15,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Temukan santapan yang ramah\nlambung dan aman dari alergi tubuhmu.",

                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        _tag("Cek Alergi"),

                        const SizedBox(width: 8),

                        _tag("Cek Pantangan"),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,

                            foregroundColor: AppColors.primary,

                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,

                              vertical: 7,
                            ),
                          ),

                          onPressed: () {},

                          child: const Text(
                            "Lihat Rekomendasi",

                            style: TextStyle(fontSize: 10),
                          ),
                        ),

                        const Text(
                          "8 Menu Tersedia",

                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _titleRow("Aktivitas Hari Ini", "Hari ini"),

              const SizedBox(height: 8),

              Container(
                height: 120,

                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),

                      decoration: const BoxDecoration(
                        color: Color(0xffF1F5F9),

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.calendar_today_outlined,

                        size: 18,

                        color: Color(0xff94A3B8),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Belum Ada Rutinitas Terjadwal",

                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,

        selectedItemColor: AppColors.primary,

        unselectedItemColor: const Color(0xff94A3B8),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),

            label: "Beranda",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),

            label: "Profil",
          ),
        ],
      ),
    );
  }

  Widget _menuCard(
    IconData icon,

    String title,

    String subtitle,

    Color iconColor,

    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Container(
            width: 34,

            height: 34,

            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),

            child: Icon(icon, color: iconColor, size: 18),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: const TextStyle(
                    fontWeight: FontWeight.bold,

                    fontSize: 11,
                  ),
                ),

                Text(
                  subtitle,

                  style: const TextStyle(fontSize: 9, color: Color(0xff64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _titleRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          title,

          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),

        Text(
          value,

          style: const TextStyle(fontSize: 10, color: Color(0xff64748B)),
        ),
      ],
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

      decoration: BoxDecoration(
        color: Colors.white24,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,

        style: const TextStyle(fontSize: 8, color: Colors.white),
      ),
    );
  }
}
