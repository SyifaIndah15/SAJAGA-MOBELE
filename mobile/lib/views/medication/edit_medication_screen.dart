import 'package:flutter/material.dart';

/// Screen Edit Jadwal Obat Khusus Hari Ini (Saat Jadwal Terlewat) - SAJAGA App
/// Lokasi file: lib/views/medication/edit_medication_screen.dart
class EditMedicationScreen extends StatefulWidget {
  final String medicationName;
  final String dosage;
  final String frequencyTarget;
  final List<EditDoseItem> initialDoses;

  const EditMedicationScreen({
    super.key,
    this.medicationName = 'Sangobion',
    this.dosage = '500 mg',
    this.frequencyTarget = 'Target: 3 Kali',
    this.initialDoses = const [
      EditDoseItem(
        label: 'Dosis Pagi',
        routineTime: '08.00',
        actualTime: '07.15',
        tag: 'JAM 1',
        iconType: DoseIconType.morning,
        status: DoseEditStatus.alreadyTaken,
        note: 'Tercatat diminum pukul 07.15 WIB (Tidak dapat diubah)',
      ),
      EditDoseItem(
        label: 'Dosis Siang',
        routineTime: '13.00',
        actualTime: '14.00',
        tag: 'JAM 2',
        iconType: DoseIconType.afternoon,
        status: DoseEditStatus.rescheduled,
        note: 'Jarak interval aman: 6 jam 45 menit dari Dosis Pagi',
      ),
      EditDoseItem(
        label: 'Dosis Malam',
        routineTime: '20.00',
        actualTime: '20.00',
        tag: 'JAM 3',
        iconType: DoseIconType.night,
        status: DoseEditStatus.adjusted,
        note: 'Interval ideal: 7 jam dari Dosis Siang untuk penyerapan optimal',
      ),
    ],
  });

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _doseController;
  late List<EditDoseItem> _doses;

  String _selectedFrequency = '3x Sehari';
  final List<String> _frequencies = [
    '1x Sehari',
    '2x Sehari',
    '3x Sehari',
    'Sesuai Kebutuhan',
  ];

  MealInstruction _mealInstruction = MealInstruction.afterMeal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicationName);
    _doseController = TextEditingController(text: widget.dosage);
    _doses = List.from(widget.initialDoses);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(int index) async {
    if (_doses[index].status == DoseEditStatus.alreadyTaken) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dosis ini sudah diminum dan tidak dapat diubah.'),
          backgroundColor: Color(0xFF64748B),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final currentTimeStr = _doses[index].actualTime;
    final parts = currentTimeStr.split('.');
    final initialTime = TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 14,
      minute: parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0,
    );

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      final formattedHour = picked.hour.toString().padLeft(2, '0');
      final formattedMinute = picked.minute.toString().padLeft(2, '0');
      setState(() {
        _doses[index] = _doses[index].copyWith(
          actualTime: '$formattedHour.$formattedMinute',
        );

        if (_doses[index].label == 'Dosis Siang' && _doses.length > 2) {
          int nextHour = (picked.hour + 6) % 24;
          final nextHourStr = nextHour.toString().padLeft(2, '0');
          _doses[2] = _doses[2].copyWith(
            actualTime: '$nextHourStr.00',
            note: 'Interval ideal: disesuaikan dari Dosis Siang ($formattedHour.$formattedMinute)',
          );
        }
      });
    }
  }

  void _saveChanges() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Jadwal penyesuaian khusus hari ini untuk "${_nameController.text}" berhasil disimpan!',
        ),
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

                    _buildFrequencySection(),
                    const SizedBox(height: 22),

                    _buildDosageScheduleSection(),
                    const SizedBox(height: 22),

                    _buildFieldLabel('Instruksi Terkait Jam Makan'),
                    const SizedBox(height: 10),
                    _buildMealInstructionCard(),
                    const SizedBox(height: 20),

                    _buildSpecialNoticeCard(),
                    const SizedBox(height: 22),

                    _buildFieldLabel('Pratinjau Pengingat Hari Ini'),
                    const SizedBox(height: 10),
                    _buildPreviewCard(),
                    const SizedBox(height: 24),

                    _buildSubmitButton(),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Notifikasi alarm akan diperbarui secara otomatis di perangkat Anda.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 17,
                backgroundColor: Color(0xFF0288D1),
                child: Icon(Icons.medical_services_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Edit Jadwal Obat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            ],
          ),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF0288D1),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        if (isRequired) ...[
          const SizedBox(width: 3),
          const Text('*', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
        ],
      ],
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2)),
      child: TextField(
        controller: _nameController,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14), border: InputBorder.none, suffixIcon: Icon(Icons.medication_outlined, color: Color(0xFF0288D1))),
      ),
    );
  }

  Widget _buildDoseField() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2)),
      child: TextField(
        controller: _doseController,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14), border: InputBorder.none, suffixIcon: Icon(Icons.vaccines_outlined, color: Color(0xFF0288D1))),
      ),
    );
  }

  Widget _buildFrequencySection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Frekuensi Konsumsi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text(widget.frequencyTarget, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0288D1))),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 12, childAspectRatio: 3.1),
          itemCount: _frequencies.length,
          itemBuilder: (context, index) {
            final item = _frequencies[index];
            final bool isSelected = _selectedFrequency == item;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: isSelected ? const Color(0xFFBAE6FD) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? const Color(0xFF0288D1) : const Color(0xFFE2E8F0))),
              child: Row(
                children: [
                  CircleAvatar(radius: 5, backgroundColor: isSelected ? const Color(0xFF0288D1) : Colors.transparent),
                  const SizedBox(width: 8),
                  Text(item, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, color: isSelected ? const Color(0xFF0369A1) : const Color(0xFF475569))),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDosageScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Jadwal Waktu Minum Hari Ini', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text('${_doses.length} kali per hari', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _doses.any((d) => d.status == DoseEditStatus.alreadyTaken)
              ? 'Dosis 1 telah selesai tercatat. Anda dapat mengatur ulang Dosis 2 dan Dosis 3.'
              : 'Atur ulang jadwal dosis untuk hari ini sesuai ritme harian Anda.',
          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 12),
        ..._doses.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final bool isTaken = item.status == DoseEditStatus.alreadyTaken;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF1F5F9))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: isTaken ? const Color(0xFFE0F2FE) : const Color(0xFFBAE6FD),
                          child: Icon(isTaken ? Icons.done_all : Icons.wb_sunny_rounded, color: const Color(0xFF0288D1), size: 20),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text(isTaken ? 'Sudah Diminum' : item.status == DoseEditStatus.rescheduled ? 'Diatur Ulang' : 'Disesuaikan', style: const TextStyle(fontSize: 10, color: Color(0xFF0288D1))),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => _pickTime(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: isTaken ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B))),
                        child: Row(
                          children: [
                            Text(item.actualTime, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isTaken ? const Color(0xFF64748B) : const Color(0xFF1E293B))),
                            const SizedBox(width: 6),
                            Icon(isTaken ? Icons.lock_outline_rounded : Icons.access_time_rounded, size: 16, color: isTaken ? const Color(0xFF94A3B8) : const Color(0xFF0288D1)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.note, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMealInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFF1F5F9))),
      child: const Text('Anjuran Waktu Konsumsi: Setelah Makan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildSpecialNoticeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F9FF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFBAE6FD), width: 1.2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Icon(Icons.info_rounded, color: Color(0xFF0288D1), size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pemberitahuan Khusus: Pengaturan ini hanya berlaku untuk hari ini. Jadwal akan otomatis kembali ke setelan awal (jadwal rutin) mulai esok hari setelah dosis malam selesai diminum.',
              style: TextStyle(fontSize: 11, color: Color(0xFF0C4A6E), height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF8FCFF), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE0F2FE))),
      child: const Text('Penyesuaian Khusus Hari Ini - Status: Siap Aktif', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0288D1))),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0288D1), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
        child: const Text('SIMPAN PERUBAHAN JADWAL', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

enum MealInstruction { beforeMeal, afterMeal }
enum DoseIconType { morning, afternoon, night }
enum DoseEditStatus { alreadyTaken, rescheduled, adjusted }

class EditDoseItem {
  final String label;
  final String routineTime;
  final String actualTime;
  final String tag;
  final DoseIconType iconType;
  final DoseEditStatus status;
  final String note;

  const EditDoseItem({
    required this.label,
    required this.routineTime,
    required this.actualTime,
    required this.tag,
    required this.iconType,
    required this.status,
    required this.note,
  });

  EditDoseItem copyWith({
    String? label,
    String? routineTime,
    String? actualTime,
    String? tag,
    DoseIconType? iconType,
    DoseEditStatus? status,
    String? note,
  }) {
    return EditDoseItem(
      label: label ?? this.label,
      routineTime: routineTime ?? this.routineTime,
      actualTime: actualTime ?? this.actualTime,
      tag: tag ?? this.tag,
      iconType: iconType ?? this.iconType,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}
