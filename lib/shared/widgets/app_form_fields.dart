import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AppFormDecorations {
  static InputDecoration filled({
    String? hintText,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.studentsCardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.studentsCardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
    );
  }
}

class AppLabeledField extends StatelessWidget {
  const AppLabeledField({
    super.key,
    required this.label,
    required this.child,
    this.width,
    this.spacing = 10,
  });

  final String label;
  final Widget child;
  final double? width;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.formLabel),
        SizedBox(height: spacing),
        child,
      ],
    );

    if (width == null) return content;
    return SizedBox(width: width, child: content);
  }
}

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.height = 56,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.expands = false,
    this.contentPadding,
  });

  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final double height;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool expands;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        maxLines: expands ? null : maxLines,
        expands: expands,
        decoration: AppFormDecorations.filled(
          hintText: hintText,
          contentPadding:
              contentPadding ??
              (expands
                  ? const EdgeInsets.all(16)
                  : const EdgeInsets.symmetric(horizontal: 16)),
        ),
      ),
    );
  }
}

class AppDropdownFormField<T> extends StatelessWidget {
  const AppDropdownFormField({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.hintText,
    this.height = 56,
    this.isExpanded = true,
    this.itemBuilder,
  });

  final List<T> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String? hintText;
  final double height;
  final bool isExpanded;
  final Widget Function(T value)? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DropdownButtonFormField<T>(
        key: value == null ? null : ValueKey<T?>(value),
        initialValue: value,
        validator: validator,
        isExpanded: isExpanded,
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: itemBuilder?.call(item) ?? Text('$item'),
              ),
            )
            .toList(),
        onChanged: onChanged,
        decoration: AppFormDecorations.filled(hintText: hintText ?? ''),
      ),
    );
  }
}

class AppDateButton extends StatelessWidget {
  const AppDateButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon = Icons.calendar_today_outlined,
    this.height = 56,
  });

  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          side: const BorderSide(color: AppColors.studentsCardBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTypography.bodySmall)),
            Icon(icon, size: 18, color: AppColors.iconMuted),
          ],
        ),
      ),
    );
  }
}

String formatCompactDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final String month = months[(date.month - 1).clamp(0, months.length - 1)];
  final String day = date.day.toString().padLeft(2, '0');
  return '$day $month ${date.year}';
}
