import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_constant.dart';

class MealHistoryScreen extends StatefulWidget {
  const MealHistoryScreen({super.key});

  @override
  State<MealHistoryScreen> createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadMealHistory();
  }

  Future<void> _loadMealHistory() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('Pengguna belum login.');
      }

      final result = await _supabase
          .from('activity_histories')
          .select('''
            id,
            meal_schedule_id,
            status,
            note,
            activity_time,
            created_at,
            meal_schedules!inner(
              id,
              user_id,
              meal_type,
              schedule_time,
              is_active
            )
          ''')
          .eq('meal_schedules.user_id', user.id)
          .not('meal_schedule_id', 'is', null)
          .order('activity_time', ascending: false);

      if (!mounted) return;
      setState(() {
        _history = List<Map<String, dynamic>>.from(result);
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Gagal memuat riwayat makan: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Riwayat makan gagal dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.navy),
        title: const Text(
          'Riwayat Makan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
      ),
      body: RefreshIndicator(onRefresh: _loadMealHistory, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 220),
          Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ],
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          const SizedBox(height: 100),
          const Icon(Icons.error_outline, color: AppColors.grey, size: 42),
          const SizedBox(height: 12),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _loadMealHistory,
              child: const Text('Coba Lagi'),
            ),
          ),
        ],
      );
    }

    final groupedHistory = _groupHistoryByDate();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 22),
        if (_history.isEmpty)
          _buildEmptyState()
        else
          ...groupedHistory.entries.map(
            (entry) => _buildHistoryGroup(entry.key, entry.value),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 72, bottom: 48),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: AppColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.restaurant_outlined,
              color: AppColors.primary,
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Belum Ada Riwayat Makan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Aktivitas makan yang kamu tandai sebagai sudah dilakukan '
            'akan tercatat dan muncul di halaman ini.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.5, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final total = _history.length;
    final completedCount = _history.where((item) {
      return _normalizeStatus(item['status']) == 'completed';
    }).length;
    final skippedCount = _history.where((item) {
      return _normalizeStatus(item['status']) == 'skipped';
    }).length;

    final percentage = total == 0
        ? 0
        : ((completedCount / total) * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.white, AppColors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Row(
        children: [
          _buildIcon(Icons.restaurant_outlined, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$percentage% Pola Makan Teratur',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$completedCount dari $total aktivitas makan selesai',
                  style: const TextStyle(fontSize: 11, color: AppColors.grey),
                ),
                if (skippedCount > 0) ...[
                  const SizedBox(height: 3),
                  Text(
                    '$skippedCount aktivitas dilewati',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              total > 0 && completedCount == total ? 'Optimal' : 'Dipantau',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Map<String, dynamic>>> _groupHistoryByDate() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final item in _history) {
      final activityTime = _parseDateTime(item['activity_time']);
      if (activityTime == null) continue;

      final key = _dateKey(activityTime);
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(item);
    }
    return grouped;
  }

  Widget _buildHistoryGroup(String dateKey, List<Map<String, dynamic>> items) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final groupDate = DateTime(date.year, date.month, date.day);
    final difference = today.difference(groupDate).inDays;

    final title = difference == 0
        ? 'Hari Ini'
        : difference == 1
        ? 'Kemarin'
        : _formatDate(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(
          title,
          _formatDate(date),
          difference == 0 ? AppColors.primary : AppColors.grey,
        ),
        const SizedBox(height: 12),
        ...items.map(_buildMealCardFromData),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDateHeader(String title, String date, Color dotColor) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: dotColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        const Spacer(),
        Text(date, style: const TextStyle(fontSize: 11, color: AppColors.grey)),
      ],
    );
  }

  Widget _buildMealCardFromData(Map<String, dynamic> item) {
    final schedule = item['meal_schedules'] as Map<String, dynamic>?;
    final mealType = schedule?['meal_type']?.toString() ?? 'Makan';
    final activityTime = _parseDateTime(item['activity_time']);
    final time = activityTime == null ? '-' : _formatTime(activityTime);
    final status = _normalizeStatus(item['status']);
    final note = item['note']?.toString().trim();

    return _buildMealCard(
      title: _formatMealType(mealType),
      time: '$time WIB',
      icon: _getMealIcon(mealType),
      status: status,
      note: (note == null || note.isEmpty) ? null : note,
    );
  }

  Widget _buildMealCard({
    required String title,
    required String time,
    required IconData icon,
    required String status,
    String? note,
  }) {
    final isSkipped = status == 'skipped';
    final isCompleted = status == 'completed';
    final statusLabel = isSkipped
        ? 'Dilewati'
        : isCompleted
        ? 'Selesai'
        : 'Tercatat';

    final statusColor = isSkipped
        ? const Color(0xFFB45309)
        : isCompleted
        ? const Color(0xFF059669)
        : AppColors.grey;

    final statusBackground = isSkipped
        ? const Color(0xFFFFF7ED)
        : isCompleted
        ? const Color(0xFFECFDF5)
        : const Color(0xFFF3F4F6);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Row(
        children: [
          _buildIcon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        isSkipped
                            ? '$time • Jadwal dilewati'
                            : '$time • $statusLabel',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                if (note != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: const TextStyle(fontSize: 10, color: AppColors.grey),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: statusBackground,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor.withOpacity(0.18)),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, {double size = 20}) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: AppColors.primary),
    );
  }

  String _normalizeStatus(dynamic value) {
    final status = value?.toString().toLowerCase().trim();
    switch (status) {
      case 'taken':
      case 'completed':
      case 'done':
      case 'selesai':
        return 'completed';
      case 'skipped':
      case 'skip':
      case 'dilewati':
        return 'skipped';
      default:
        return status ?? '';
    }
  }

  String _formatMealType(String mealType) {
    switch (mealType.toLowerCase().trim()) {
      case 'sarapan':
      case 'sarapan pagi':
      case 'breakfast':
        return 'Sarapan Pagi';
      case 'makan siang':
      case 'siang':
      case 'lunch':
        return 'Makan Siang';
      case 'makan malam':
      case 'malam':
      case 'dinner':
        return 'Makan Malam';
      default:
        return mealType;
    }
  }

  IconData _getMealIcon(String mealType) {
    final normalized = mealType.toLowerCase().trim();
    if (normalized.contains('sarapan') || normalized.contains('breakfast')) {
      return Icons.breakfast_dining_outlined;
    }
    if (normalized.contains('malam') || normalized.contains('dinner')) {
      return Icons.nightlight_outlined;
    }
    return Icons.wb_sunny_outlined;
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value.toLocal();
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }
}
