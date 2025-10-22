import 'package:ai_tutor_web/features/notifications/domain/models/notification_filters.dart';
import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
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
    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SearchField(controller: searchController),
          const SizedBox(height: 16),
          _FilterDropdown<NotificationStatus>(
            value: selectedStatus,
            options: statusOptions,
            onChanged: onStatusChanged,
          ),
          const SizedBox(height: 12),
          _FilterDropdown<NotificationType>(
            value: selectedType,
            options: typeOptions,
            onChanged: onTypeChanged,
          ),
          const SizedBox(height: 12),
          _FilterDropdown<String>(
            value: selectedClass,
            options: classOptions,
            onChanged: onClassChanged,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _SearchField(controller: searchController)),
        const SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: _FilterDropdown<NotificationStatus>(
                  value: selectedStatus,
                  options: statusOptions,
                  onChanged: onStatusChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _FilterDropdown<NotificationType>(
                  value: selectedType,
                  options: typeOptions,
                  onChanged: onTypeChanged,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _FilterDropdown<String>(
                  value: selectedClass,
                  options: classOptions,
                  onChanged: onClassChanged,
                ),
              ),
            ],
          ),
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

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T? value;
  final List<FilterOption<T>> options;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    assert(options.isNotEmpty, 'options must not be empty');
    final FilterOption<T> selectedOption = options.firstWhere(
      (option) => option.value == value,
      orElse: () => options.first,
    );

    return SizedBox(
      height: 48,
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.searchFieldBackground,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.searchFieldBorder),
          ),
          child: DropdownButton<FilterOption<T>>(
            value: selectedOption,
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.iconMuted,
            ),
            onChanged: (option) => onChanged(option?.value),
            items: options
                .map(
                  (option) => DropdownMenuItem<FilterOption<T>>(
                    value: option,
                    child: Text(option.label),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
