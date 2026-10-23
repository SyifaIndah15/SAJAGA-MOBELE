import 'package:flutter/material.dart';
import '../../config/app_constant.dart';
import '../widgets/medication_form_field.dart';

class EditMedicationScreen extends StatefulWidget {
  final String medicationId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final String mealInstruction;
  final List<EditableSchedule> initialSchedules;

  const EditMedicationScreen({
    super.key,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.mealInstruction,
    required this.initialSchedules,
  });

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  late List<EditableSchedule> _schedules;

  @override
  void initState() {
    super.initState();
    _schedules = List.from(widget.initialSchedules);
  }

  void _updateScheduleTime(int index, String newTime) {
    setState(() {
      _schedules[index] = _schedules[index].copyWith(
        time: newTime,
        isAdjusted: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicationFormField(
              label: 'Nama Obat',
              hintText: widget.medicationName,
              suffixIcon: Icons.link,
              isRequired: true,
              enabled: false,
            ),
            const SizedBox(height: 16),
            MedicationFormField(
              label: 'Dosis',
              hintText: widget.dosage,
              suffixIcon: Icons.medication,
              isRequired: true,
              enabled: false,
            ),
            const SizedBox(height: 20),
            _buildFrequencySection(),
            const SizedBox(height: 20),
            _buildScheduleSection(),
            const SizedBox(height: 20),
            _buildMealInstructionSection(),
            const SizedBox(height: 20),
            _buildSpecialNotice(),
            const SizedBox(height: 24),
            _buildPreviewSection(),
            const SizedBox(height: 16),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Edit Jadwal Obat',
        style: TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.navy,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            backgroundColor: AppColors.lightBlue,
            child: const Icon(Icons.person, color: AppColors.primary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySection() {
    final targetCount = _getTargetCount();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Frekuensi Konsumsi'),
            Text(
              'Target: $targetCount Kali',
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _FrequencyOption(label: '1x Sehari', isSelected: widget.frequency == '1x Sehari'),
            _FrequencyOption(label: '2x Sehari', isSelected: widget.frequency == '2x Sehari'),
            _FrequencyOption(label: '3x Sehari', isSelected: widget.frequency == '3x Sehari'),
            _FrequencyOption(label: 'Sesuai Kebutuhan', isSelected: widget.frequency == 'Sesuai Kebutuhan'),
          ],
        ),
      ],
    );
  }

  int _getTargetCount() {
    switch (widget.frequency) {
      case '1x Sehari': return 1;
      case '2x Sehari': return 2;
      case '3x Sehari': return 3;
      default: return _schedules.length;
    }
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Jadwal Waktu Minum Hari Ini'),
            Text(
              '${_schedules.length} kali per hari',
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Atur ulang jadwal ${_schedules.first.label} untuk hari ini sesuai ritme harian Anda.',
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 12),
        ..._schedules.asMap().entries.map((entry) {
          final index = entry.key;
          final schedule = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _EditableScheduleItem(
              schedule: schedule,
              onTimeChanged: (newTime) => _updateScheduleTime(index, newTime),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMealInstructionSection() {
    final isBeforeMeal = widget.mealInstruction == 'Sebelum Makan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Instruksi Terkait Jam Makan'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.restaurant, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Anjuran Waktu Konsumsi',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MealToggle(label: 'Sebelum Makan', isSelected: isBeforeMeal),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MealToggle(label: 'Setelah Makan', isSelected: !isBeforeMeal),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pemberitahuan Khusus',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pengaturan ini hanya berlaku untuk hari ini. Jadwal akan otomatis kembali ke setelan awal (jadwal rutin) mulai besok hari setelah dosis malam selesai diminum.',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Pratinjau Pengingat Hari Ini'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.medicationName,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.dosage,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ..._schedules.map((schedule) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _PreviewTimelineItem(
                      time: '${schedule.time} WIB',
                      meal: widget.mealInstruction,
                      label: schedule.label,
                      isAdjusted: schedule.isAdjusted,
                    ),
                  )),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, color: AppColors.primary, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Penyesuaian Khusus Hari Ini',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 11,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Status: Siap Aktif',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _handleSave,
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: const Text(
              'SIMPAN PERUBAHAN JADWAL',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Notifikasi alarm akan diperbarui secara otomatis di perangkat Anda.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  void _handleSave() {
    print('Simpan perubahan jadwal untuk obat ${widget.medicationName}');
    Navigator.pop(context);
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.navy,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════

class EditableSchedule {
  final String label;
  final String time;
  final String tag;
  final bool isAdjusted;

  const EditableSchedule({
    required this.label,
    required this.time,
    required this.tag,
    this.isAdjusted = false,
  });

  EditableSchedule copyWith({
    String? label,
    String? time,
    String? tag,
    bool? isAdjusted,
  }) {
    return EditableSchedule(
      label: label ?? this.label,
      time: time ?? this.time,
      tag: tag ?? this.tag,
      isAdjusted: isAdjusted ?? this.isAdjusted,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS
// ═══════════════════════════════════════════════════════════════

class _FrequencyOption extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FrequencyOption({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6, // ← PERBAIKAN: pakai Opacity widget, bukan parameter BoxDecoration
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lightBlue : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightBlue.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey.withValues(alpha: 0.4),
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableScheduleItem extends StatelessWidget {
  final EditableSchedule schedule;
  final ValueChanged<String> onTimeChanged;

  const _EditableScheduleItem({
    required this.schedule,
    required this.onTimeChanged,
  });

  IconData _getIcon() {
    if (schedule.label.toLowerCase().contains('pagi')) return Icons.wb_sunny_outlined;
    if (schedule.label.toLowerCase().contains('siang')) return Icons.wb_sunny;
    if (schedule.label.toLowerCase().contains('malam')) return Icons.nightlight_round;
    return Icons.access_time;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(), color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.label,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    if (schedule.isAdjusted) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Disesuaikan',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sesuai interval optimal',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: _parseTime(schedule.time),
                  );
                  if (picked != null) {
                    final formatted = '${picked.hour.toString().padLeft(2, '0')}.${picked.minute.toString().padLeft(2, '0')}';
                    onTimeChanged(formatted);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.navy, width: 1.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        schedule.time,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.access_time, color: AppColors.navy, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  schedule.tag,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (schedule.isAdjusted) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 14),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Interval aman untuk penyerapan optimal tubuh',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split('.');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }
}

class _MealToggle extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _MealToggle({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6, // ← PERBAIKAN: pakai Opacity widget
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.navy,
          ),
        ),
      ),
    );
  }
}

class _PreviewTimelineItem extends StatelessWidget {
  final String time;
  final String meal;
  final String label;
  final bool isAdjusted;

  const _PreviewTimelineItem({
    required this.time,
    required this.meal,
    required this.label,
    required this.isAdjusted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            Container(width: 2, height: 40, color: AppColors.lightBlue),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$meal • $label${isAdjusted ? " • Disesuaikan" : ""}',
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_outlined, color: AppColors.grey, size: 20),
      ],
    );
  }
}