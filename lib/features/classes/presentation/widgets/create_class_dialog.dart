import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class CreateClassRequest {
  const CreateClassRequest({
    required this.className,
    required this.board,
    this.section,
    this.startDate,
  });

  final String className;
  final String board;
  final String? section;
  final DateTime? startDate;
}

class CreateClassDialog extends StatefulWidget {
  const CreateClassDialog({super.key, required this.boardOptions});

  final List<String> boardOptions;

  static const double dialogWidth = 620;
  static const double contentWidth = 580;
  static const double fieldHeight = 48;
  static const double buttonHeight = 48;

  @override
  State<CreateClassDialog> createState() => _CreateClassDialogState();
}

class _CreateClassDialogState extends State<CreateClassDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _classNameController;
  late final TextEditingController _sectionController;
  DateTime? _selectedDate;
  String? _selectedBoard;

  @override
  void initState() {
    super.initState();
    _classNameController = TextEditingController();
    _sectionController = TextEditingController();
    _selectedBoard = widget.boardOptions.isNotEmpty
        ? widget.boardOptions.first
        : null;
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 1);
    final DateTime lastDate = DateTime(now.year + 5);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final request = CreateClassRequest(
      className: _classNameController.text.trim(),
      board: _selectedBoard ?? '',
      section: _sectionController.text.trim().isEmpty
          ? null
          : _sectionController.text.trim(),
      startDate: _selectedDate,
    );

    Navigator.of(context).pop(request);
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets contentPadding = const EdgeInsets.symmetric(
      horizontal: 36,
      vertical: 32,
    );

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: CreateClassDialog.dialogWidth,
        ),
        child: Padding(
          padding: contentPadding,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'New Class',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Class Name',
                  child: _TextField(
                    controller: _classNameController,
                    hintText: 'e.g., Class 10',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Class name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Board',
                  child: _DropdownField(
                    value: _selectedBoard,
                    options: widget.boardOptions,
                    onChanged: (value) =>
                        setState(() => _selectedBoard = value),
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Section (Optional)',
                  child: _TextField(
                    controller: _sectionController,
                    hintText: 'e.g., A',
                    validator: (_) => null,
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Start Date',
                  child: _DateField(date: _selectedDate, onPickDate: _pickDate),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: CreateClassDialog.buttonHeight,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: CreateClassDialog.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Create'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: CreateClassDialog.contentWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.formLabel),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CreateClassDialog.fieldHeight,
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
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
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CreateClassDialog.fieldHeight,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: options
            .map(
              (option) => DropdownMenuItem(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
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
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onPickDate});

  final DateTime? date;
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    final String label = date == null
        ? 'Select start date'
        : '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}';

    return SizedBox(
      height: CreateClassDialog.fieldHeight,
      child: OutlinedButton(
        onPressed: onPickDate,
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
            Text(label, style: AppTypography.bodySmall),
            const Spacer(),
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.iconMuted,
            ),
          ],
        ),
      ),
    );
  }
}
