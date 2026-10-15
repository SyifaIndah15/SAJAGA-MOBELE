import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/meal_card.dart';
import '../../config/app_constant.dart';
import '../../utils/snackbar_helper.dart';

class MealScheduleScreen extends StatefulWidget {
  const MealScheduleScreen({super.key});

  @override
  State<MealScheduleScreen> createState() => _MealScheduleScreenState();
}

class _MealScheduleScreenState extends State<MealScheduleScreen> {
  TimeOfDay _breakfastTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _lunchTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _dinnerTime = const TimeOfDay(hour: 19, minute: 0);

  bool _isBreakfastActive = true;
  bool _isLunchActive = true;
  bool _isDinnerActive = true;

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false, // <-- Judul di kiri, bukan tengah
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant_menu, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            const Text(
              'Nutrisi & Jadwal',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_outline, color: AppColors.white, size: 20),
            ),
            onPressed: () {
              // TODO: Nanti navigasi ke ProfileScreen
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Jadwal & Menu Harian',
              style: TextStyle(
                color: AppColors.navy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Jadwal dan rekomendasi menu otomatis',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  MealCard(
                    title: 'Sarapan',
                    subtitle: 'Pukul santap pagi',
                    icon: Icons.wb_sunny_outlined,
                    iconColor: Colors.orange,
                    time: _formatTime(_breakfastTime),
                    isActive: _isBreakfastActive,
                    onTimeTap: () => _showTimePicker(
                      'Sarapan',
                      _breakfastTime,
                      (newTime) => setState(() => _breakfastTime = newTime),
                    ),
                    onToggleChanged: (value) => setState(() => _isBreakfastActive = value),
                  ),
                  const SizedBox(height: 12),
                  MealCard(
                    title: 'Makan Siang',
                    subtitle: 'Pukul jeda siang',
                    icon: Icons.wb_sunny,
                    iconColor: AppColors.secondary,
                    time: _formatTime(_lunchTime),
                    isActive: _isLunchActive,
                    onTimeTap: () => _showTimePicker(
                      'Makan Siang',
                      _lunchTime,
                      (newTime) => setState(() => _lunchTime = newTime),
                    ),
                    onToggleChanged: (value) => setState(() => _isLunchActive = value),
                  ),
                  const SizedBox(height: 12),
                  MealCard(
                    title: 'Makan Malam',
                    subtitle: 'Pukul santap tenang',
                    icon: Icons.nightlight_round,
                    iconColor: AppColors.navy,
                    time: _formatTime(_dinnerTime),
                    isActive: _isDinnerActive,
                    onTimeTap: () => _showTimePicker(
                      'Makan Malam',
                      _dinnerTime,
                      (newTime) => setState(() => _dinnerTime = newTime),
                    ),
                    onToggleChanged: (value) => setState(() => _isDinnerActive = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  SnackbarHelper.showSuccess(context, 'Pengaturan berhasil disimpan!');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'SIMPAN PENGATURAN',
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimePicker(
    String mealName,
    TimeOfDay initialTime,
    ValueChanged<TimeOfDay> onSelected,
  ) {
    TimeOfDay tempTime = initialTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // <-- PENTING: biar bisa scroll
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return SingleChildScrollView( // <-- Bungkus dengan ini
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.lightBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wb_sunny_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atur Waktu $mealName',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navy,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Tentukan waktu pengingat ${mealName.toLowerCase()} harian Anda',
                                style: const TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.grey, size: 20),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8), // Kurangi dari 12
                    // Time Picker - KURANGI TINGGI dari 120 jadi 100
                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'JAM',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                    scrollController: FixedExtentScrollController(
                                      initialItem: tempTime.hour,
                                    ),
                                    itemExtent: 32, // Kurangi dari 36
                                    onSelectedItemChanged: (index) {
                                      setModalState(() {
                                        tempTime = TimeOfDay(
                                          hour: index,
                                          minute: tempTime.minute,
                                        );
                                      });
                                    },
                                    children: List.generate(
                                      24,
                                      (index) => Center(
                                        child: Text(
                                          index.toString().padLeft(2, '0'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.navy,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            ':',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'MENIT',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                    scrollController: FixedExtentScrollController(
                                      initialItem: tempTime.minute,
                                    ),
                                    itemExtent: 32, // Kurangi dari 36
                                    onSelectedItemChanged: (index) {
                                      setModalState(() {
                                        tempTime = TimeOfDay(
                                          hour: tempTime.hour,
                                          minute: index,
                                        );
                                      });
                                    },
                                    children: List.generate(
                                      60,
                                      (index) => Center(
                                        child: Text(
                                          index.toString().padLeft(2, '0'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: AppColors.navy,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8), // Kurangi dari 12
                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppColors.primary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Waktu ${mealName.toLowerCase()} otomatis disinkronkan ke kalender metabolisme dan menu saji.',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8), // Kurangi dari 12
                    // Tombol Simpan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onSelected(tempTime);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 12), // Kurangi dari 14
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Simpan Waktu',
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Tombol Batal
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}