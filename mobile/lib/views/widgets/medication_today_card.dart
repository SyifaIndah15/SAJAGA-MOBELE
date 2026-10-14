import 'package:flutter/material.dart';

class MedicationTodayCard extends StatelessWidget {
  final String timeCategory;
  final String statusText;
  final String medicationName;
  final String dosageInfo;
  final bool isTaken;
  final bool isLate;
  final String? warningMessage;
  final VoidCallback? onTapAction;

  const MedicationTodayCard({
    super.key,
    required this.timeCategory,
    required this.statusText,
    required this.medicationName,
    required this.dosageInfo,
    this.isTaken = false,
    this.isLate = false,
    this.warningMessage,
    this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    Color cardBorderColor = isLate ? Colors.red.shade200 : Colors.transparent;
    Color bgColor = isLate ? const Color(0xFFFFF5F5) : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isLate ? Icons.error_outline : Icons.access_time_rounded,
                    size: 16,
                    color: isLate ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    timeCategory,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isLate ? Colors.red : Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isTaken
                      ? Colors.green.shade50
                      : (isLate ? Colors.red.shade50 : Colors.blue.shade50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isTaken
                        ? Colors.green.shade700
                        : (isLate ? Colors.red.shade700 : Colors.blue.shade700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicationName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dosageInfo,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (warningMessage != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.red),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      warningMessage!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}