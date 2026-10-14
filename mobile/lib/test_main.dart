import 'package:flutter/material.dart';

// Import keempat widget utama dengan nama file yang presisi
import 'views/widgets/medication_today_card.dart';
import 'views/widgets/meal_schedule_card.dart';
import 'views/widgets/food_recommendation_card.dart';
import 'views/widgets/activity_status_badge.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAJAGA UI Tester',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool isMeal1Active = true;
  bool isMeal2Active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Debugger - SAJAGA'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Activity Status Badges
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '1. Activity Status Badges',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActivityStatusBadge(
                    label: 'Diminum',
                    type: ActivityBadgeType.diminum,
                  ),
                  ActivityStatusBadge(
                    label: 'Terlewat',
                    type: ActivityBadgeType.terlewat,
                  ),
                  ActivityStatusBadge(
                    label: 'Selesai',
                    type: ActivityBadgeType.selesai,
                  ),
                  ActivityStatusBadge(
                    label: 'Optimal',
                    type: ActivityBadgeType.optimal,
                  ),
                  ActivityStatusBadge(
                    label: 'Akan Datang',
                    type: ActivityBadgeType.akanDatang,
                  ),
                ],
              ),
            ),
            const Divider(height: 32),

            // 2. Medication Today Cards
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '2. Medication Today Cards',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            MedicationTodayCard(
              timeCategory: '07.00 Pagi',
              statusText: 'Diminum',
              medicationName: 'Sangobion',
              dosageInfo: '1 kapsul • sesudah makan',
              isTaken: true,
            ),
            MedicationTodayCard(
              timeCategory: '14.00 Siang',
              statusText: 'Terlewat > 1 jam',
              medicationName: 'Sangobion',
              dosageInfo: '1 kapsul • jeda dosis...',
              isLate: true,
              warningMessage:
                  'Jadwal terlewat lebih dari 1 jam. Silakan sesuaikan kembali jadwal minum obat Anda agar jeda dosis tetap aman.',
              onTapAction: () {},
            ),
            const Divider(height: 32),

            // 3. Meal Schedule Cards
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '3. Meal Schedule Cards',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            MealScheduleCard(
              icon: Icons.wb_sunny_rounded,
              mealTitle: 'Sarapan',
              mealSubtitle: 'Pukul santap pagi',
              time: '07.00',
              isEnabled: isMeal1Active,
              onSwitchChanged: (val) {
                setState(() {
                  isMeal1Active = val;
                });
              },
              onTapTime: () {},
            ),
            MealScheduleCard(
              icon: Icons.nightlight_round,
              mealTitle: 'Makan Malam',
              mealSubtitle: 'Pukul santap tenang',
              time: '19.00',
              isEnabled: isMeal2Active,
              onSwitchChanged: (val) {
                setState(() {
                  isMeal2Active = val;
                });
              },
              onTapTime: () {},
            ),
            const Divider(height: 32),

            // 4. Food Recommendation Cards
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '4. Food Recommendation Cards',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            FoodRecommendationCard(
              title: 'Bubur Jahe Ayam Suwir',
              description:
                  'Tekstur lembut hangat dengan sari jahe alami, efektif meredakan sensasi mual.',
              calories: '245 kkal',
              mealType: 'Sarapan',
              tag: 'Ramah Maag',
              imageUrl:
                  'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=200',
              onTapDetail: () {},
            ),
            FoodRecommendationCard(
              title: 'Sup Bening Labu Siam',
              description:
                  'Kaya serat dan air yang sangat lembut dan ramah pencernaan.',
              calories: '160 kkal',
              mealType: 'Makan Siang',
              tag: 'Tinggi Serat',
              imageUrl:
                  'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=200',
              onTapDetail: () {},
            ),
          ],
        ),
      ),
    );
  }
}