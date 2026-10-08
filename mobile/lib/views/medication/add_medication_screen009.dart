import 'package:flutter/material.dart';

/// Screen untuk Menambah Jadwal Obat Baru (Add Medication Screen) - SAJAGA App
/// Lokasi file: lib/views/medication/add_medication_screen.dart
class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Amoxicillin');
  final TextEditingController _doseController =
      TextEditingController(text: '500 mg, 1 Kaplet');

  String _selectedFrequency = '3x Sehari';
  final List<String> _frequencies = [
    '1x Sehari',
    '2x Sehari',
    '3x Sehari',
    'Sesuai Kebutuhan',
  ];

  List<DoseScheduleTime> _dosageTimes = [
    DoseScheduleTime(
      label: 'Dosis Pagi',
      time: '07.00',
      tag: 'JAM 1',
      iconType: TimeIconType.morning,
    ),
    DoseScheduleTime(
      label: 'Dosis Siang',
      time: '13.00',
      tag: 'JAM 2',
      iconType: TimeIconType.afternoon,
    ),
    DoseScheduleTime(
      label: 'Dosis Malam',
      time: '21.00',
      tag: 'JAM 3',
      iconType: TimeIconType.night,
    ),
  ];

  int _durationDays = 7;
  MealInstruction _mealInstruction = MealInstruction.afterMeal;

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(int index) async {
    final currentTimeStr = _dosageTimes[index].time;
    final parts = currentTimeStr.split('.');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 7,
      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0288D1),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedHour = picked.hour.toString().padLeft(2, '0');
      final formattedMinute = picked.minute.toString().padLeft(2, '0');
      setState(() {
        _dosageTimes[index] = _dosageTimes[index].copyWith(
          time: '$formattedHour.$formattedMinute',
        );
      });
    }
  }

  void _addDosageTime() {
    setState(() {
      final newIndex = _dosageTimes.length + 1;
      _dosageTimes.add(
        DoseScheduleTime(
          label: 'Dosis Tambahan',
          time: '18.00',
          tag: 'JAM $newIndex',
          iconType: TimeIconType.afternoon,
        ),
      );
    });
  }

  void _saveMedication() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama obat wajib diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Jadwal obat "${_nameController.text}" berhasil disimpan!'),
        backgroundColor: const Color(0xFF0288D1),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FD),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Nama Obat', isRequired: true),
                    const SizedBox(height: 6),
                    _buildNameField(),
                    const SizedBox(height: 18),

                    _buildFieldLabel('Dosis', isRequired: true),
                    const SizedBox(height: 6),
                    _buildDoseField(),
                    const SizedBox(height: 20),

                    _buildFieldLabel('Frekuensi Konsumsi'),
                    const SizedBox(height: 10),
                    _buildFrequencyGrid(),
                    const SizedBox(height: 22),

                    _buildDosageScheduleSection(),
                    const SizedBox(height: 22),

                    _buildFieldLabel('Durasi Konsumsi'),
                    const SizedBox(height: 10),
                    _buildDurationCard(),
                    const SizedBox(height: 22),

                    _buildFieldLabel('Instruksi Terkait Jam Makan'),
                    const SizedBox(height: 10),
                    _buildMealInstructionCard(),
                    const SizedBox(height: 24),

                    _buildFieldLabel('Pratinjau Pengingat Hari Ini'),
                    const SizedBox(height: 10),
                    _buildPreviewCard(),
                    const SizedBox(height: 24),

                    _buildSubmitButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF334155), size: 24),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFF0288D1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Tambah Jadwal Obat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0288D1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        ),
        if (isRequired) ...[
          const SizedBox(width: 3),
          const Text('*', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        ],
      ],
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: TextField(
        controller: _nameController,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          border: InputBorder.none,
          hintText: 'Masukkan nama obat',
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: Icon(Icons.medication_outlined, color: Color(0xFF0288D1), size: 22),
          ),
        ),
        onChanged: (val) => setState(() {}),
      ),
    );
  }

  Widget _buildDoseField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
      ),
      child: TextField(
        controller: _doseController,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          border: InputBorder.none,
          hintText: 'Contoh: 500 mg, 1 Kaplet',
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: Icon(Icons.vaccines_outlined, color: Color(0xFF0288D1), size: 22),
          ),
        ),
        onChanged: (val) => setState(() {}),
      ),
    );
  }

  Widget _buildFrequencyGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 12,
        childAspectRatio: 3.1,
      ),
      itemCount: _frequencies.length,
      itemBuilder: (context, index) {
        final item = _frequencies[index];
        final bool isSelected = _selectedFrequency == item;

        return InkWell(
          onTap: () => setState(() => _selectedFrequency = item),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFBAE6FD) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? const Color(0xFF0288D1) : const Color(0xFFE2E8F0),
                width: isSelected ? 1.4 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0288D1) : const Color(0xFF94A3B8),
                      width: 1.8,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 9,
                            height: 9,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? const Color(0xFF0369A1) : const Color(0xFF475569),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDosageScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Jadwal Waktu Minum',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
            Text(
              '${_dosageTimes.length} kali per hari',
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._dosageTimes.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: _buildDosageTimeCard(item, index),
          );
        }),
        const SizedBox(height: 4),
        InkWell(
          onTap: _addDosageTime,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.alarm_add_rounded, color: Color(0xFF0288D1), size: 18),
                SizedBox(width: 8),
                Text(
                  'Tambah Jam Minum',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0288D1)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDosageTimeCard(DoseScheduleTime item, int index) {
    IconData icon;
    Color iconColor;

    switch (item.iconType) {
      case TimeIconType.morning:
        icon = Icons.wb_sunny_outlined;
        iconColor = const Color(0xFF0288D1);
        break;
      case TimeIconType.afternoon:
        icon = Icons.wb_sunny_rounded;
        iconColor = const Color(0xFF0288D1);
        break;
      case TimeIconType.night:
        icon = Icons.nightlight_round;
        iconColor = const Color(0xFF475569);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE0F2FE), width: 1),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  const SizedBox(height: 3),
                  InkWell(
                    onTap: () => _pickTime(index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF94A3B8), width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Text(item.time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10),
                          const Icon(Icons.access_time_rounded, color: Color(0xFF64748B), size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              item.tag,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF64748B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$_durationDays Hari', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              const Text('Hingga resep selesai\ndihabiskan', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    if (_durationDays > 1) setState(() => _durationDays--);
                  },
                  icon: const Icon(Icons.remove, size: 18, color: Color(0xFF475569)),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text('$_durationDays', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  onPressed: () => setState(() => _durationDays++),
                  icon: const Icon(Icons.add, size: 18, color: Color(0xFF475569)),
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.restaurant_rounded, color: Color(0xFF0288D1), size: 18),
              SizedBox(width: 8),
              Text('Anjuran Waktu Konsumsi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMealOptionButton(
                  title: 'Sebelum Makan',
                  isSelected: _mealInstruction == MealInstruction.beforeMeal,
                  onTap: () => setState(() => _mealInstruction = MealInstruction.beforeMeal),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMealOptionButton(
                  title: 'Setelah Makan',
                  isSelected: _mealInstruction == MealInstruction.afterMeal,
                  onTap: () => setState(() => _mealInstruction = MealInstruction.afterMeal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealOptionButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0288D1) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0288D1) : const Color(0xFFE2E8F0)),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final mealText = _mealInstruction == MealInstruction.afterMeal ? 'Setelah Makan' : 'Sebelum Makan';
    final medName = _nameController.text.trim().isEmpty ? 'Nama Obat' : _nameController.text.trim();
    final doseText = _doseController.text.trim().isEmpty ? 'Dosis' : _doseController.text.split(',')[0].trim();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE0F2FE), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF0288D1), shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(medName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(14)),
                child: Text(doseText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0288D1))),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ..._dosageTimes.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == _dosageTimes.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(width: 12, height: 12, decoration: const BoxDecoration(color: Color(0xFF0288D1), shape: BoxShape.circle)),
                    if (!isLast) Container(width: 2, height: 38, color: const Color(0xFFBAE6FD)),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.time} WIB', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(mealText, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                        const Icon(Icons.notifications_outlined, color: Color(0xFF64748B), size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, color: Color(0xFF0288D1), size: 15),
                  const SizedBox(width: 6),
                  Text('Berjalan selama $_durationDays hari', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
              const Text('Status: Siap Aktif', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0288D1))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveMedication,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0288D1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline_rounded, size: 20),
            SizedBox(width: 8),
            Text('SIMPAN OBAT', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
          ],
        ),
      ),
    );
  }
}

enum MealInstruction { beforeMeal, afterMeal }
enum TimeIconType { morning, afternoon, night }

class DoseScheduleTime {
  final String label;
  final String time;
  final String tag;
  final TimeIconType iconType;

  DoseScheduleTime({
    required this.label,
    required this.time,
    required this.tag,
    required this.iconType,
  });

  DoseScheduleTime copyWith({
    String? label,
    String? time,
    String? tag,
    TimeIconType? iconType,
  }) {
    return DoseScheduleTime(
      label: label ?? this.label,
      time: time ?? this.time,
      tag: tag ?? this.tag,
      iconType: iconType ?? this.iconType,
    );
  }
}
