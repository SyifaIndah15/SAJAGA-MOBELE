import 'package:flutter/material.dart';
import '../../config/app_constant.dart';
import '../widgets/medication_form_field.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();

  // State
  String _selectedFrequency = '3x Sehari';
  String _selectedMealInstruction = 'Setelah Makan';
  int _durationDays = 7;
  List<ScheduleTime> _schedules = [];

  @override
  void initState() {
    super.initState();
    // Default 3x sehari
    _updateSchedulesFromFrequency('3x Sehari');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  // Update jadwal berdasarkan frekuensi
  void _updateSchedulesFromFrequency(String frequency) {
    setState(() {
      _selectedFrequency = frequency;
      _schedules.clear();

      switch (frequency) {
        case '1x Sehari':
          _schedules.add(ScheduleTime(label: 'Dosis Pagi', time: '07.00', tag: 'JAM 1'));
          break;
        case '2x Sehari':
          _schedules.add(ScheduleTime(label: 'Dosis Pagi', time: '07.00', tag: 'JAM 1'));
          _schedules.add(ScheduleTime(label: 'Dosis Malam', time: '21.00', tag: 'JAM 2'));
          break;
        case '3x Sehari':
          _schedules.add(ScheduleTime(label: 'Dosis Pagi', time: '07.00', tag: 'JAM 1'));
          _schedules.add(ScheduleTime(label: 'Dosis Siang', time: '13.00', tag: 'JAM 2'));
          _schedules.add(ScheduleTime(label: 'Dosis Malam', time: '21.00', tag: 'JAM 3'));
          break;
        case 'Sesuai Kebutuhan':
          // Tidak ada default, user tambah manual
          break;
      }
    });
  }

  void _addNewSchedule() {
    setState(() {
      _schedules.add(ScheduleTime(
        label: 'Dosis ${_schedules.length + 1}',
        time: '08.00',
        tag: 'JAM ${_schedules.length + 1}',
      ));
    });
  }

  void _removeSchedule(int index) {
    setState(() {
      _schedules.removeAt(index);
    });
  }

  void _updateScheduleTime(int index, String newTime) {
    setState(() {
      _schedules[index] = _schedules[index].copyWith(time: newTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Nama Obat & Dosis (pakai MedicationFormField)
              MedicationFormField(
                label: 'Nama Obat',
                hintText: 'Amoxicillin',
                suffixIcon: Icons.link,
                isRequired: true,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              MedicationFormField(
                label: 'Dosis',
                hintText: '500 mg, 1 Kaplet',
                suffixIcon: Icons.medication,
                isRequired: true,
                controller: _doseController,
              ),
              const SizedBox(height: 20),

              // Frekuensi Konsumsi
              _buildFrequencySection(),
              const SizedBox(height: 20),

              // Jadwal Waktu Minum
              _buildScheduleSection(),
              const SizedBox(height: 20),

              // Durasi Konsumsi
              _buildDurationSection(),
              const SizedBox(height: 20),

              // Instruksi Jam Makan
              _buildMealInstructionSection(),
              const SizedBox(height: 24),

              // Pratinjau Pengingat
              _buildPreviewSection(),
              const SizedBox(height: 16),

              // Tombol Simpan
              _buildSaveButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.navy, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Tambah Jadwal Obat',
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

  // ─── Frekuensi Konsumsi ───────────────────────────────────
  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Frekuensi Konsumsi'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _FrequencyOption(
              label: '1x Sehari',
              value: '1x Sehari',
              groupValue: _selectedFrequency,
              onChanged: _updateSchedulesFromFrequency,
            ),
            _FrequencyOption(
              label: '2x Sehari',
              value: '2x Sehari',
              groupValue: _selectedFrequency,
              onChanged: _updateSchedulesFromFrequency,
            ),
            _FrequencyOption(
              label: '3x Sehari',
              value: '3x Sehari',
              groupValue: _selectedFrequency,
              onChanged: _updateSchedulesFromFrequency,
            ),
            _FrequencyOption(
              label: 'Sesuai Kebutuhan',
              value: 'Sesuai Kebutuhan',
              groupValue: _selectedFrequency,
              onChanged: _updateSchedulesFromFrequency,
            ),
          ],
        ),
      ],
    );
  }

  // ─── Jadwal Waktu Minum ────────────────────────────────────
  Widget _buildScheduleSection() {
    final isCustomFrequency = _selectedFrequency == 'Sesuai Kebutuhan';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionTitle('Jadwal Waktu Minum'),
            if (!isCustomFrequency)
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
        const SizedBox(height: 12),

        // Tampilkan list jadwal
        if (_schedules.isNotEmpty)
          ..._schedules.asMap().entries.map((entry) {
            final index = entry.key;
            final schedule = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _ScheduleTimeItem(
                schedule: schedule,
                onTimeChanged: (newTime) => _updateScheduleTime(index, newTime),
                onRemove: _schedules.length > 1 ? () => _removeSchedule(index) : null,
              ),
            );
          }),

        // Tombol Tambah Jam Minum
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _addNewSchedule,
            icon: const Icon(Icons.access_time, color: AppColors.primary, size: 18),
            label: const Text(
              'Tambah Jam Minum',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: AppColors.lightBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Durasi Konsumsi ───────────────────────────────────────
  Widget _buildDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Durasi Konsumsi'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '7 Hari',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hingga resep selesai dihabiskan',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildDurationButton(Icons.remove, () {
                    if (_durationDays > 1) setState(() => _durationDays--);
                  }),
                  const SizedBox(width: 16),
                  Text(
                    '$_durationDays',
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildDurationButton(Icons.add, () {
                    setState(() => _durationDays++);
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 18, color: AppColors.navy),
      ),
    );
  }

  // ─── Instruksi Jam Makan ───────────────────────────────────
  Widget _buildMealInstructionSection() {
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
                  _MealToggle(
                    label: 'Sebelum Makan',
                    isSelected: _selectedMealInstruction == 'Sebelum Makan',
                    onTap: () => setState(() => _selectedMealInstruction = 'Sebelum Makan'),
                  ),
                  const SizedBox(width: 12),
                  _MealToggle(
                    label: 'Setelah Makan',
                    isSelected: _selectedMealInstruction == 'Setelah Makan',
                    onTap: () => setState(() => _selectedMealInstruction = 'Setelah Makan'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Pratinjau Pengingat ───────────────────────────────────
  Widget _buildPreviewSection() {
    final drugName = _nameController.text.isEmpty ? 'Amoxicillin' : _nameController.text;
    final drugDose = _doseController.text.isEmpty ? '500 mg' : _doseController.text;

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
              // Header
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
                      drugName,
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
                      drugDose,
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

              // List jadwal
              if (_schedules.isNotEmpty)
                ..._schedules.map((schedule) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _PreviewTimelineItem(
                        time: '${schedule.time} WIB',
                        meal: _selectedMealInstruction,
                      ),
                    )),

              const Divider(height: 1),
              const SizedBox(height: 12),

              // Footer status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.primary, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Berjalan selama $_durationDays hari',
                          style: const TextStyle(
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

  // ─── Tombol Simpan ─────────────────────────────────────────
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // TODO: Simpan data ke Supabase
            print('Nama: ${_nameController.text}');
            print('Dosis: ${_doseController.text}');
            print('Frekuensi: $_selectedFrequency');
            print('Jadwal: $_schedules');
            print('Durasi: $_durationDays hari');
            print('Instruksi: $_selectedMealInstruction');
          }
        },
        icon: const Icon(Icons.check_circle_outline, size: 20),
        label: const Text(
          'SIMPAN OBAT',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
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
    );
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

class ScheduleTime {
  final String label;
  final String time;
  final String tag;

  const ScheduleTime({
    required this.label,
    required this.time,
    required this.tag,
  });

  ScheduleTime copyWith({String? label, String? time, String? tag}) {
    return ScheduleTime(
      label: label ?? this.label,
      time: time ?? this.time,
      tag: tag ?? this.tag,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPER WIDGETS (Private - hanya untuk screen ini)
// ═══════════════════════════════════════════════════════════════

class _FrequencyOption extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _FrequencyOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _isSelected ? AppColors.lightBlue : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: _isSelected ? AppColors.primary : AppColors.lightBlue.withOpacity(0.5),
            width: _isSelected ? 1.5 : 1,
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
                color: _isSelected ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: _isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.4),
                ),
              ),
              child: _isSelected
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
                color: _isSelected ? AppColors.primary : AppColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTimeItem extends StatelessWidget {
  final ScheduleTime schedule;
  final ValueChanged<String> onTimeChanged;
  final VoidCallback? onRemove;

  const _ScheduleTimeItem({
    required this.schedule,
    required this.onTimeChanged,
    this.onRemove,
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
        border: Border.all(color: AppColors.lightBlue.withOpacity(0.5)),
      ),
      child: Row(
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
                    fontSize: 12,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 4),
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
                  child: Row(
                    children: [
                      Text(
                        schedule.time,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time, color: AppColors.grey, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              schedule.tag,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, color: AppColors.grey, size: 20),
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
  final VoidCallback onTap;

  const _MealToggle({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.grey.withOpacity(0.3),
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
      ),
    );
  }
}

class _PreviewTimelineItem extends StatelessWidget {
  final String time;
  final String meal;

  const _PreviewTimelineItem({
    required this.time,
    required this.meal,
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
                meal,
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