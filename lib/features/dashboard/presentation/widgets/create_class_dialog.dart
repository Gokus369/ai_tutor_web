import 'package:ai_tutor_web/shared/models/school_option.dart';
import 'package:ai_tutor_web/shared/widgets/app_dialog_shell.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
import 'package:flutter/material.dart';

class CreateClassRequest {
  const CreateClassRequest({
    required this.className,
    required this.board,
    required this.schoolId,
    required this.boardId,
    this.section,
    this.startDate,
  });

  final String className;
  final String board;
  final int schoolId;
  final int boardId;
  final String? section;
  final DateTime? startDate;
}

class CreateClassDialog extends StatefulWidget {
  const CreateClassDialog({
    super.key,
    required this.boardOptions,
    this.schoolOptions = const [],
    this.initial,
    this.title = 'New Class',
    this.confirmLabel = 'Create',
  });

  final List<String> boardOptions;
  final List<SchoolOption>? schoolOptions;
  final CreateClassRequest? initial;
  final String title;
  final String confirmLabel;

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
  late final TextEditingController _schoolIdController;
  DateTime? _selectedDate;
  String? _selectedBoard;
  int? _selectedSchoolId;
  late final List<SchoolOption> _schoolOptions;
  int _selectedBoardId = 1;

  @override
  void initState() {
    super.initState();
    _schoolOptions = widget.schoolOptions ?? const [];
    _classNameController = TextEditingController();
    _sectionController = TextEditingController();
    _schoolIdController = TextEditingController();
    _selectedBoard = widget.boardOptions.isNotEmpty
        ? widget.boardOptions.first
        : null;
    if (_schoolOptions.isNotEmpty) {
      _selectedSchoolId = _schoolOptions.first.id;
      _schoolIdController.text = _selectedSchoolId!.toString();
    }
    final initial = widget.initial;
    if (initial != null) {
      _classNameController.text = initial.className;
      _sectionController.text = initial.section ?? '';
      _selectedDate = initial.startDate;
      _selectedBoardId = initial.boardId;
      if (widget.boardOptions.contains(initial.board)) {
        _selectedBoard = initial.board;
      } else {
        _selectedBoardId = _resolveBoardId(_selectedBoard);
      }
      if (_schoolOptions.isNotEmpty) {
        final hasSchool = _schoolOptions.any((s) => s.id == initial.schoolId);
        _selectedSchoolId =
            hasSchool ? initial.schoolId : _schoolOptions.first.id;
      } else {
        _selectedSchoolId = initial.schoolId;
      }
      _schoolIdController.text = initial.schoolId.toString();
    }
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _sectionController.dispose();
    _schoolIdController.dispose();
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

    final int? resolvedSchoolId = _selectedSchoolId;
    if (resolvedSchoolId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a school')),
      );
      return;
    }

    final request = CreateClassRequest(
      className: _classNameController.text.trim(),
      board: _selectedBoard ?? '',
      schoolId: resolvedSchoolId,
      boardId: _selectedBoardId,
      section: _sectionController.text.trim().isEmpty
          ? null
          : _sectionController.text.trim(),
      startDate: _selectedDate,
    );

    Navigator.of(context).pop(request);
  }

  int _resolveBoardId(String? boardName) {
    switch (boardName?.toLowerCase()) {
      case 'cbse':
        return 1;
      case 'icse':
        return 2;
      case 'state board':
        return 3;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: widget.title,
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
                onChanged: (value) {
                  setState(() {
                    _selectedBoard = value;
                    _selectedBoardId = _resolveBoardId(value);
                  });
                },
                height: CreateClassDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: CreateClassDialog.contentWidth,
              label: 'School',
              child: _schoolOptions.isEmpty
                  ? AppTextFormField(
                      controller: _schoolIdController,
                      hintText: 'Enter school ID',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final trimmed = (value ?? '').trim();
                        if (trimmed.isEmpty) return 'School is required';
                        final parsed = int.tryParse(trimmed);
                        if (parsed == null) return 'Must be a number';
                        _selectedSchoolId = parsed;
                        return null;
                      },
                      height: CreateClassDialog.fieldHeight,
                    )
                  : AppDropdownFormField<int>(
                      value: _selectedSchoolId,
                      items: _schoolOptions.map((s) => s.id).toList(),
                      itemBuilder: (id) {
                        final name = _schoolOptions
                            .firstWhere((s) => s.id == id)
                            .name;
                        return Text(name);
                      },
                      onChanged: (value) => setState(() => _selectedSchoolId = value),
                      decoration: AppFormDecorations.filled(),
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
                primaryLabel: widget.confirmLabel,
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
