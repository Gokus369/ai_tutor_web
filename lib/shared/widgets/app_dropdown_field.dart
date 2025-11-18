import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.hintText,
    this.width,
    this.height = 56,
    this.decoration,
    this.spacing = 6,
    this.isExpanded = true,
    this.itemBuilder,
  });

  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String? hintText;
  final double? width;
  final double height;
  final InputDecoration? decoration;
  final double spacing;
  final bool isExpanded;
  final Widget Function(T value)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.classCardMeta.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing),
        AppDropdownFormField<T>(
          items: items,
          value: value,
          onChanged: onChanged,
          validator: validator,
          hintText: hintText,
          height: height,
          isExpanded: isExpanded,
          itemBuilder: itemBuilder,
          decoration:
              decoration ??
              InputDecoration(
                filled: true,
                fillColor: AppColors.studentsFilterBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.studentsFilterBorder,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.studentsFilterBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
              ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );

    if (width == null) return field;
    return SizedBox(width: width, child: field);
  }
}
