import 'package:ai_tutor_web/features/notifications/domain/models/notification_filters.dart';
import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/widgets/app_dropdown_field.dart';
import 'package:ai_tutor_web/shared/widgets/filter_panel.dart';
import 'package:flutter/material.dart';

class NotificationFiltersBar extends StatelessWidget {
  const NotificationFiltersBar({
    super.key,
    required this.isCompact,
    required this.searchController,
    required this.statusOptions,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.typeOptions,
    required this.selectedType,
    required this.onTypeChanged,
    required this.classOptions,
    required this.selectedClass,
    required this.onClassChanged,
  });

  final bool isCompact;
  final TextEditingController searchController;
  final List<FilterOption<NotificationStatus>> statusOptions;
  final NotificationStatus? selectedStatus;
  final ValueChanged<NotificationStatus?> onStatusChanged;
  final List<FilterOption<NotificationType>> typeOptions;
  final NotificationType? selectedType;
  final ValueChanged<NotificationType?> onTypeChanged;
  final List<FilterOption<String>> classOptions;
  final String? selectedClass;
  final ValueChanged<String?> onClassChanged;

  @override
  Widget build(BuildContext context) {
    final statusSelection = _resolveSelectedOption(
      statusOptions,
      selectedStatus,
    );
    final typeSelection = _resolveSelectedOption(typeOptions, selectedType);
    final classSelection = _resolveSelectedOption(classOptions, selectedClass);
    final bool stack = isCompact;

    return FilterPanel(
      breakpoint: 940,
      forceColumn: stack ? true : null,
      children: [
        SizedBox(
          width: stack ? double.infinity : 320,
          child: _SearchField(controller: searchController),
        ),
        AppDropdownField<FilterOption<NotificationStatus>>(
          label: 'Status',
          items: statusOptions,
          value: statusSelection,
          onChanged: (option) => onStatusChanged(option?.value),
          width: stack ? null : 180,
          itemBuilder: (option) => Text(option.label),
        ),
        AppDropdownField<FilterOption<NotificationType>>(
          label: 'Type',
          items: typeOptions,
          value: typeSelection,
          onChanged: (option) => onTypeChanged(option?.value),
          width: stack ? null : 180,
          itemBuilder: (option) => Text(option.label),
        ),
        AppDropdownField<FilterOption<String>>(
          label: 'Class',
          items: classOptions,
          value: classSelection,
          onChanged: (option) => onClassChanged(option?.value),
          width: stack ? null : 180,
          itemBuilder: (option) => Text(option.label),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search notifications...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
          filled: true,
          fillColor: AppColors.searchFieldBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.searchFieldBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.searchFieldBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
          ),
        ),
      ),
    );
  }
}

FilterOption<T> _resolveSelectedOption<T>(
  List<FilterOption<T>> options,
  T? value,
) {
  assert(options.isNotEmpty, 'options must not be empty');
  return options.firstWhere(
    (option) => option.value == value,
    orElse: () => options.first,
  );
}
