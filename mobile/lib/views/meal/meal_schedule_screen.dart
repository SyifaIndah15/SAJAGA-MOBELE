import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../widgets/meal_card.dart';
import '../../config/app_constant.dart';
import '../../services/meal_service.dart';

class MealScheduleScreen extends StatefulWidget {
  const MealScheduleScreen({super.key});

  @override
  State<MealScheduleScreen> createState() => _MealScheduleScreenState();
}

class _MealScheduleScreenState extends State<MealScheduleScreen> {
  final MealService _mealService = MealService();

  TimeOfDay _breakfastTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _lunchTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _dinnerTime = const TimeOfDay(hour: 19, minute: 0);

  bool _isBreakfastActive = true;
  bool _isLunchActive = true;
  bool _isDinnerActive = true;

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadMealSchedules();
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay _parseTime(dynamic value, TimeOfDay fallback) {
    if (value == null) return fallback;

    final parts = value.toString().split(':');
    if (parts.length < 2) return fallback;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return fallback;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _loadMealSchedules() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final schedules = await _mealService.getMealSchedules();

      TimeOfDay breakfast = const TimeOfDay(hour: 7, minute: 0);
      TimeOfDay lunch = const TimeOfDay(hour: 12, minute: 0);
      TimeOfDay dinner = const TimeOfDay(hour: 19, minute: 0);

      bool breakfastActive = true;
      bool lunchActive = true;
      bool dinnerActive = true;

      for (final schedule in schedules) {
        final type = schedule['meal_type']?.toString();
        final time = schedule['schedule_time'];
        final active = schedule['is_active'] != false;

        switch (type) {
          case 'breakfast':
            breakfast = _parseTime(time, breakfast);
            breakfastActive = active;
            break;
          case 'lunch':
            lunch = _parseTime(time, lunch);
            lunchActive = active;
            break;
          case 'dinner':
            dinner = _parseTime(time, dinner);
            dinnerActive = active;
            break;
        }
      }

      if (!mounted) return;

      setState(() {
        _breakfastTime = breakfast;
        _lunchTime = lunch;
        _dinnerTime = dinner;
        _isBreakfastActive = breakfastActive;
        _isLunchActive = lunchActive;
        _isDinnerActive = dinnerActive;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Gagal memuat jadwal makan: $e')),
        );
    }
  }

  Future<void> _handleSave() async {
    if (_isSaving || _isLoading) return;

    setState(() => _isSaving = true);

    try {
      await _mealService.saveAllMealSchedules(
        breakfastTime: _formatTime(_breakfastTime),
        breakfastActive: _isBreakfastActive,
        lunchTime: _formatTime(_lunchTime),
        lunchActive: _isLunchActive,
        dinnerTime: _formatTime(_dinnerTime),
        dinnerActive: _isDinnerActive,
      );

      if (!mounted) return;

      // Mengirim true agar Home memuat ulang jadwal dari Supabase.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Gagal menyimpan jadwal makan: $e')),
        );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.navy,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.restaurant_menu,
              color: AppColors.primary,
              size: 22,
            ),
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
              child: const Icon(
                Icons.person_outline,
                color: AppColors.white,
                size: 20,
              ),
            ),
            onPressed: () {
              // Navigasi profil belum diubah.
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
              'Atur waktu pengingat makan harian Anda',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
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
                            (value) => setState(() => _breakfastTime = value),
                          ),
                          onToggleChanged: (value) {
                            setState(() => _isBreakfastActive = value);
                          },
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
                            (value) => setState(() => _lunchTime = value),
                          ),
                          onToggleChanged: (value) {
                            setState(() => _isLunchActive = value);
                          },
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
                            (value) => setState(() => _dinnerTime = value),
                          ),
                          onToggleChanged: (value) {
                            setState(() => _isDinnerActive = value);
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isLoading || _isSaving) ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                    : const Text(
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
    int selectedHour = initialTime.hour;
    int selectedMinute = initialTime.minute;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.grey,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(sheetContext),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 110,
                      child: Row(
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
                                    scrollController:
                                        FixedExtentScrollController(
                                          initialItem: selectedHour,
                                        ),
                                    itemExtent: 32,
                                    onSelectedItemChanged: (index) {
                                      setModalState(() {
                                        selectedHour = index;
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
                                    scrollController:
                                        FixedExtentScrollController(
                                          initialItem: selectedMinute,
                                        ),
                                    itemExtent: 32,
                                    onSelectedItemChanged: (index) {
                                      setModalState(() {
                                        selectedMinute = index;
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
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Waktu pengingat $mealName akan disimpan sebagai jadwal harian.',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onSelected(
                            TimeOfDay(
                              hour: selectedHour,
                              minute: selectedMinute,
                            ),
                          );
                          Navigator.pop(sheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                    TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: AppColors.grey, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
