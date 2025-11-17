import 'package:ai_tutor_web/shared/widgets/app_dialog_shell.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
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
    return AppDialogShell(
      title: 'New Class',
      width: CreateClassDialog.dialogWidth,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLabeledField(
              width: CreateClassDialog.contentWidth,
              label: 'Class Name',
              child: AppTextFormField(
                controller: _classNameController,
                hintText: 'e.g., Class 10',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Class name is required';
                  }
                  return null;
                },
                height: CreateClassDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: CreateClassDialog.contentWidth,
              label: 'Board',
              child: AppDropdownFormField<String>(
                items: widget.boardOptions,
                value: _selectedBoard,
                onChanged: (value) => setState(() => _selectedBoard = value),
                height: CreateClassDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: CreateClassDialog.contentWidth,
              label: 'Section (Optional)',
              child: AppTextFormField(
                controller: _sectionController,
                hintText: 'e.g., A',
                validator: (_) => null,
                height: CreateClassDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: CreateClassDialog.contentWidth,
              label: 'Start Date',
              child: AppDateButton(
                label: _selectedDate == null
                    ? 'Select start date'
                    : formatCompactDate(_selectedDate!),
                onTap: _pickDate,
                height: CreateClassDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: AppDialogActions(
                primaryLabel: 'Create',
                onPrimaryPressed: _handleSubmit,
                onCancel: () => Navigator.of(context).pop(),
                buttonSize: const Size(140, CreateClassDialog.buttonHeight),
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
