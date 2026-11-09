import 'package:flutter/material.dart';

import '../../config/app_constant.dart';

class MedicationFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextEditingController? controller;
  final bool isRequired;
  final TextInputType keyboardType;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const MedicationFormField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = AppColors.lightBlue.withOpacity(0.65);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.navy,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          onChanged: onChanged,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            color: AppColors.navy,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              color: enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.primary, size: 17)
                : null,
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: AppColors.primary, size: 17)
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 38,
              minHeight: 36,
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 38,
              minHeight: 36,
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.3,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
            ),
          ),
        ),
      ],
    );
  }
}
