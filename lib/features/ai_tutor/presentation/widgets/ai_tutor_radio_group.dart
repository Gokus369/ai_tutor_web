import 'package:ai_tutor_web/features/ai_tutor/domain/models/ai_tutor_models.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AiTutorRadioGroup extends StatelessWidget {
  const AiTutorRadioGroup({
    super.key,
    required this.label,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.optionKeyBuilder,
  });

  final String label;
  final List<AiTutorRadioOption> options;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final Key Function(AiTutorRadioOption option)? optionKeyBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        RadioGroup<String>(
          groupValue: groupValue,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          child: Column(
            children: options.map((option) {
              final bool selected = option.value == groupValue;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.sidebarBorder,
                  ),
                  color: AppColors.white,
                ),
                child: RadioListTile<String>(
                  key: optionKeyBuilder?.call(option),
                  value: option.value,
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  activeColor: AppColors.primary,
                  title: Text(
                    option.label,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: option.subtitle != null
                      ? Text(
                          option.subtitle!,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyMuted,
                          ),
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
