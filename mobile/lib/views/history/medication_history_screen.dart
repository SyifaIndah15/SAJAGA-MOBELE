import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/app_constant.dart';

class MedicationHistoryScreen extends StatefulWidget {
  const MedicationHistoryScreen({super.key});

  @override
  State<MedicationHistoryScreen> createState() =>
      _MedicationHistoryScreenState();
}

class _MedicationHistoryScreenState
    extends State<MedicationHistoryScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;

  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadMedicationHistory();
  }

  Future<void> _loadMedicationHistory() async {
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
            medication_schedule_id,
            status,
            note,
            activity_time,
            created_at,
            medication_schedules!inner(
              id,
              schedule_time,
              meal_instruction,
              medications!inner(
                id,
                name,
                dose
              )
            )
          ''')
          .eq('medication_schedules.medications.user_id', user.id)
          .not('medication_schedule_id', 'is', null)
          .order('activity_time', ascending: false);

      if (!mounted) return;

      setState(() {
        _history = List<Map<String, dynamic>>.from(result);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Riwayat obat gagal dimuat.';
      });

      debugPrint('Gagal memuat riwayat obat: $e');
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
        title: const Text(
          'Riwayat Obat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
          ),
        ),
        iconTheme: const IconThemeData(
          color: AppColors.navy,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMedicationHistory,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (_errorMessage != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          const SizedBox(height: 100),
          const Icon(
            Icons.error_outline,
            color: AppColors.grey,
            size: 42,
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: _loadMedicationHistory,
              child: const Text('Coba Lagi'),
            ),
          ),
        ],
      );
    }

    if (_history.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 24),
          const SizedBox(height: 100),
          const Icon(
            Icons.medication_outlined,
            color: AppColors.grey,
            size: 42,
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Belum ada riwayat obat.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ),
        ],
      );
    }

    final groupedHistory = _groupHistoryByDate();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        _buildSummaryCard(),
        const SizedBox(height: 24),

        ...groupedHistory.entries.map(
          (entry) => _buildHistoryGroup(
            entry.key,
            entry.value,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // SUMMARY CARD
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSummaryCard() {
    final total = _history.length;

    final takenCount = _history.where((item) {
      return _normalizeStatus(item['status']) == 'taken';
    }).length;

    final percentage = total == 0
        ? 0
        : ((takenCount / total) * 100).round();

    final isPerfect = total > 0 && takenCount == total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, AppColors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightBlue.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          _buildSummaryIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryText(
              percentage,
              takenCount,
              total,
            ),
          ),
          const SizedBox(width: 8),
          _buildSummaryBadge(isPerfect),
        ],
      ),
    );
  }

  Widget _buildSummaryIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_outline,
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  Widget _buildSummaryText(
    int percentage,
    int takenCount,
    int total,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                '$percentage% Kepatuhan Minum Obat',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.circle,
              size: 6,
              color: percentage == 100
                  ? const Color(0xFF10B981)
                  : AppColors.grey,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          '$takenCount dari $total aktivitas obat diminum',
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.grey,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryBadge(bool isPerfect) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPerfect ? 'Sempurna' : 'Dipantau',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // GROUP HISTORY
  // ═══════════════════════════════════════════════════════════════

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

  Widget _buildHistoryGroup(
    String dateKey,
    List<Map<String, dynamic>> items,
  ) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();

    final difference = DateTime(
      now.year,
      now.month,
      now.day,
    ).difference(
      DateTime(
        date.year,
        date.month,
        date.day,
      ),
    ).inDays;

    String title;

    if (difference == 0) {
      title = 'Hari Ini';
    } else if (difference == 1) {
      title = 'Kemarin';
    } else {
      title = _formatDate(date);
    }

    final dotColor = difference == 0
        ? AppColors.primary
        : AppColors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateHeader(
          title,
          _formatDate(date),
          dotColor,
        ),
        const SizedBox(height: 12),

        ...items.map(
          (item) => _buildMedicationCardFromData(item),
        ),

        const SizedBox(height: 14),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DATE HEADER
  // ═══════════════════════════════════════════════════════════════

  Widget _buildDateHeader(
    String title,
    String date,
    Color dotColor,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 4,
          backgroundColor: dotColor,
        ),
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
        Text(
          date,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MEDICATION CARD
  // ═══════════════════════════════════════════════════════════════

  Widget _buildMedicationCardFromData(
    Map<String, dynamic> item,
  ) {
    final schedule =
        item['medication_schedules'] as Map<String, dynamic>?;

    final medication =
        schedule?['medications'] as Map<String, dynamic>?;

    final name =
        medication?['name']?.toString() ?? 'Obat';

    final dosage =
        medication?['dose']?.toString() ?? '';

    final activityTime =
        _parseDateTime(item['activity_time']);

    final time = activityTime == null
        ? '-'
        : _formatTime(activityTime);

    final instruction =
        schedule?['meal_instruction']?.toString() ?? '';

    final status =
        _normalizeStatus(item['status']);

    return _buildMedicationCard(
      name: name,
      dosage: dosage,
      time: '$time WIB',
      instruction: _getInstructionText(
        status,
        instruction,
      ),
      icon: Icons.medication_outlined,
      status: status,
    );
  }

  Widget _buildMedicationCard({
    required String name,
    required String dosage,
    required String time,
    required String instruction,
    required IconData icon,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.lightBlue.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIconContainer(icon),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMedicationInfo(
              name,
              dosage,
              time,
              instruction,
            ),
          ),
          const SizedBox(width: 8),
          _buildStatusBadge(status),
        ],
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: AppColors.lightBlue,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  Widget _buildMedicationInfo(
    String name,
    String dosage,
    String time,
    String instruction,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ),
            if (dosage.isNotEmpty) ...[
              const SizedBox(width: 4),
              _buildDosageBadge(dosage),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 11,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                instruction.isEmpty
                    ? time
                    : '$time • $instruction',
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDosageBadge(String dosage) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        dosage,
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isSkipped = status == 'skipped';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: isSkipped
            ? const Color(0xFFFFE5E5)
            : AppColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSkipped
              ? const Color(0xFFFFCACA)
              : AppColors.lightBlue.withOpacity(0.5),
        ),
      ),
      child: Text(
        isSkipped ? 'Dilewati' : 'Diminum',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isSkipped
              ? const Color(0xFFE53935)
              : AppColors.primary,
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  String _normalizeStatus(dynamic value) {
    final status = value?.toString().toLowerCase().trim();

    switch (status) {
      case 'taken':
      case 'completed':
      case 'done':
      case 'diminum':
        return 'taken';

      case 'skipped':
      case 'skip':
      case 'dilewati':
        return 'skipped';

      default:
        return status ?? '';
    }
  }

  String _getInstructionText(
    String status,
    String mealInstruction,
  ) {
    if (status == 'skipped') {
      return 'Jadwal dilewati';
    }

    if (mealInstruction.isNotEmpty) {
      return mealInstruction;
    }

    return 'Diminum';
  }

  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) {
      return value.toLocal();
    }

    return DateTime.tryParse(
      value.toString(),
    )?.toLocal();
  }

  String _dateKey(DateTime date) {
    final month =
        date.month.toString().padLeft(2, '0');

    final day =
        date.day.toString().padLeft(2, '0');

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
    final hour =
        date.hour.toString().padLeft(2, '0');

    final minute =
        date.minute.toString().padLeft(2, '0');

    return '$hour.$minute';
  }
}