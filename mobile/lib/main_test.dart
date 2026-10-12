import 'package:flutter/material.dart';
import 'views/medication/edit_medication_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const EditMedicationScreen(
        medicationId: '1',
        medicationName: 'Vitamin C',
        dosage: '500 mg',
        frequency: '1x Sehari',
        mealInstruction: 'Setelah Makan',
        initialSchedules: [
          EditableSchedule(
            label: 'Dosis Malam',
            time: '20.00',
            tag: 'JAM 1',
            isAdjusted: true,
          ),
        ],
      ),
    );
  }
}