
import 'package:flutter/material.dart';

enum MedicationStatus {
  upcoming,
  ready,
  taken,
  late,
  missed,
}

class MedicationCard extends StatelessWidget {
  final String time;
  final String timeLabel;
  final String medicationName;
  final String dosage;
  final MedicationStatus status;
  final int? lateMinutes;

  final VoidCallback? onTapCheck;
  final VoidCallback? onTapMinumSekarang;
  final VoidCallback? onTapAturJadwal;
  final VoidCallback? onTapAturUlang;

  const MedicationCard({
    super.key,
    required this.time,
    required this.timeLabel,
    required this.medicationName,
    required this.dosage,
    required this.status,
    this.lateMinutes,
    this.onTapCheck,
    this.onTapMinumSekarang,
    this.onTapAturJadwal,
    this.onTapAturUlang,
  });

  static const Color _blue = Color(0xFF008ACB);
  static const Color _bluePale = Color(0xFFEAF6FD);
  static const Color _navy = Color(0xFF17243B);
  static const Color _muted = Color(0xFF71829B);
  static const Color _orange = Color(0xFFF29A00);
  static const Color _orangePale = Color(0xFFFFF8E8);
  static const Color _orangeBorder = Color(0xFFFFD98A);
  static const Color _red = Color(0xFFD92727);
  static const Color _redPale = Color(0xFFFFF5F5);
  static const Color _redBorder = Color(0xFFFFCACA);

  bool get _isLate => status == MedicationStatus.late;
  bool get _isMissed => status == MedicationStatus.missed;

  @override
  Widget build(BuildContext context) {
    if (_isMissed) return _buildMissedCard();
    if (_isLate) return _buildLateCard();

    return _buildNormalCard();
  }

  // Kartu normal: upcoming, ready, dan taken.
  Widget _buildNormalCard() {
    final accent = status == MedicationStatus.upcoming
        ? const Color(0xFFDCEFFA)
        : _blue;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5F0F8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173B59).withOpacity(0.035),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 5, color: accent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 14, 14, 14),
                  child: Row(
                    children: [
                      _buildTimeIcon(),
                      const SizedBox(width: 13),
                      Expanded(child: _buildMainText()),
                      if (status == MedicationStatus.ready) ...[
                        const SizedBox(width: 8),
                        _buildPillButton(
                          label: 'Selesai',
                          icon: Icons.check,
                          color: _blue,
                          onTap: onTapCheck,
                        ),
                      ] else if (status == MedicationStatus.taken) ...[
                        const SizedBox(width: 8),
                        _buildCheckCircle(),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Kartu kuning: sudah melewati waktu jadwal,
  // tetapi belum mencapai satu jam.
  Widget _buildLateCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _orangeBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 13, 13, 12),
              child: Row(
                children: [
                  _buildWarningIcon(
                    icon: Icons.notifications_off_outlined,
                    color: _orange,
                    background: const Color(0xFFFFF1CF),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 7,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _timeText(),
                            _statusChip(
                              'Terlewatkan',
                              _orangePale,
                              _orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _medicineName(),
                        const SizedBox(height: 2),
                        _dosageText(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPillButton(
                    label: 'Minum Sekarang',
                    icon: Icons.medication_outlined,
                    color: _orange,
                    onTap: onTapMinumSekarang,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBF1),
                border: Border(
                  top: BorderSide(color: Color(0xFFFFE8B8)),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: _orange,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Jadwal terlewat ${lateMinutes ?? 0} menit yang lalu',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 10,
                        color: Color(0xFFAA720D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu merah: sudah terlambat satu jam atau lebih.
  Widget _buildMissedCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _redBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 11),
              child: Row(
                children: [
                  _buildWarningIcon(
                    icon: Icons.notifications_off_outlined,
                    color: _red,
                    background: const Color(0xFFFFDEDE),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 3,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            _timeText(),
                            _statusChip(
                              'Terlewat',
                              const Color(0xFFFFDEDE),
                              _red,
                              icon: Icons.warning_amber_rounded,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        _medicineName(),
                        const SizedBox(height: 2),
                        _dosageText(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 7),
                  _buildPillButton(
                    label: 'Atur Jadwal',
                    icon: Icons.edit_calendar_outlined,
                    color: _blue,
                    onTap: onTapAturJadwal,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
              decoration: const BoxDecoration(
                color: _redPale,
                border: Border(
                  top: BorderSide(color: Color(0xFFFFE0E0)),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: _red,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Jadwal terlewat lebih dari 1 jam. Silakan sesuaikan kembali jadwal minum obat Anda agar jeda dosis tetap aman.',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 9,
                        height: 1.45,
                        color: _red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  _buildOutlineAction(
                    label: 'Atur Ulang',
                    icon: Icons.refresh_rounded,
                    onTap: onTapAturUlang,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 7,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _timeText(),
            if (status == MedicationStatus.ready)
              _statusChip(
                'Waktunya Minum',
                const Color(0xFFBDE8FC),
                _blue,
              ),
            if (status == MedicationStatus.taken)
              _statusChip(
                'Diminum',
                _bluePale,
                _blue,
                icon: Icons.check,
              ),
            if (status == MedicationStatus.upcoming)
              _statusChip(
                'Akan Datang',
                _bluePale,
                _orange,
              ),
          ],
        ),
        const SizedBox(height: 4),
        _medicineName(),
        const SizedBox(height: 2),
        _dosageText(),
      ],
    );
  }

  Widget _timeText() {
    return Text(
      '$time $timeLabel',
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 12,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: _muted,
      ),
    );
  }

  Widget _medicineName() {
    return Text(
      medicationName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: _navy,
      ),
    );
  }

  Widget _dosageText() {
    return Text(
      dosage,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 11,
        height: 1.35,
        color: _muted,
      ),
    );
  }

  Widget _buildTimeIcon() {
    final label = timeLabel.toLowerCase();
    final isMorning = label.contains('pagi');
    final isAfternoon = label.contains('siang');
    final isNight = label.contains('malam');

    final IconData icon;
    final Color iconColor;

    if (isMorning) {
      icon = Icons.wb_sunny_outlined;
      iconColor = _blue;
    } else if (isAfternoon) {
      icon = Icons.access_time_rounded;
      iconColor = _blue;
    } else if (isNight) {
      icon = Icons.nightlight_outlined;
      iconColor = _orange;
    } else {
      icon = Icons.wb_twilight_outlined;
      iconColor = _orange;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: _bluePale,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  Widget _buildWarningIcon({
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 21),
    );
  }

  Widget _statusChip(
    String label,
    Color background,
    Color foreground, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: foreground, size: 10),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineAction({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: _redBorder),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 11, color: _red),
              const SizedBox(width: 3),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: _red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckCircle() {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: _blue,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check,
        size: 19,
        color: Colors.white,
      ),
    );
  }
}
