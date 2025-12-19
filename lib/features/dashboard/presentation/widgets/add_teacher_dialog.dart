import 'package:ai_tutor_web/shared/models/school_option.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/widgets/app_dialog_shell.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
import 'package:flutter/material.dart';

class AddTeacherRequest {
  const AddTeacherRequest({
    required this.name,
    required this.email,
    this.phone,
    this.subject,
    this.attendance,
    this.schoolId,
    this.schoolName,
  });

  final String name;
  final String email;
  final String? phone;
  final String? subject;
  final double? attendance;
  final int? schoolId;
  final String? schoolName;
}

class AddTeacherDialog extends StatefulWidget {
  const AddTeacherDialog({
    super.key,
    this.schoolOptions = const [],
    this.subjectOptions = const [],
    this.initial,
    this.title,
    this.confirmLabel,
    this.allowEmailEdit = true,
  });

  static const double dialogWidth = 620;
  static const double contentWidth = 520;
  static const double fieldHeight = 56;
  static const double buttonHeight = 48;

  final List<SchoolOption>? schoolOptions;
  final List<String>? subjectOptions;
  final AddTeacherRequest? initial;
  final String? title;
  final String? confirmLabel;
  final bool allowEmailEdit;

  @override
  State<AddTeacherDialog> createState() => _AddTeacherDialogState();
}

class _AddTeacherDialogState extends State<AddTeacherDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  int? _selectedSchoolId;
  late final List<SchoolOption> _schoolOptions;
  late List<String> _subjectOptions;
  String? _selectedSubject;

  static const List<String> _defaultSubjects = [
    'Mathematics',
    'Science',
    'Physics',
    'Chemistry',
    'Biology',
    'English',
    'History',
    'Geography',
    'Computer Science',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _schoolOptions = widget.schoolOptions ?? const [];
    _subjectOptions = _buildSubjectOptions(widget.subjectOptions);
    final initial = widget.initial;
    if (initial != null) {
      _nameCtrl.text = initial.name;
      _emailCtrl.text = initial.email;
      _phoneCtrl.text = initial.phone ?? '';
      final subject = initial.subject?.trim();
      if (subject != null && subject.isNotEmpty) {
        _selectedSubject = subject;
        if (!_subjectOptions.contains(subject)) {
          _subjectOptions = List<String>.from(_subjectOptions)..add(subject);
        }
      }
      if (_schoolOptions.isNotEmpty) {
        final initialId = initial.schoolId;
        final hasMatch =
            initialId != null &&
            _schoolOptions.any((option) => option.id == initialId);
        _selectedSchoolId = hasMatch ? initialId : null;
      }
    } else if (_schoolOptions.isNotEmpty) {
      _selectedSchoolId = _schoolOptions.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: widget.title ?? 'Add Teacher',
      width: AddTeacherDialog.dialogWidth,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLabeledField(
              width: AddTeacherDialog.contentWidth,
              label: 'Name',
              child: AppTextFormField(
                controller: _nameCtrl,
                hintText: 'Jane Doe',
                textInputAction: TextInputAction.next,
                validator: (v) => (v ?? '').trim().isEmpty ? 'Enter a name' : null,
                height: AddTeacherDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              width: AddTeacherDialog.contentWidth,
              label: 'Email',
              child: AppTextFormField(
                controller: _emailCtrl,
                hintText: 'jane.doe@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: widget.allowEmailEdit,
                validator: (v) {
                  final trimmed = (v ?? '').trim();
                  if (!widget.allowEmailEdit && trimmed.isEmpty) return null;
                  if (trimmed.isEmpty) return 'Enter an email';
                  if (!trimmed.contains('@')) return 'Enter a valid email';
                  return null;
                },
                height: AddTeacherDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              width: AddTeacherDialog.contentWidth,
              label: 'School',
              child: AppDropdownFormField<int>(
                value: _selectedSchoolId,
                items: _schoolOptions.map((s) => s.id).toList(),
                itemBuilder: (id) => Text(
                  _schoolOptions.firstWhere((s) => s.id == id).name,
                ),
                onChanged: (value) => setState(() => _selectedSchoolId = value),
                validator: _schoolOptions.isEmpty
                    ? null
                    : (value) => value == null ? 'Select a school' : null,
                height: AddTeacherDialog.fieldHeight,
                decoration: AppFormDecorations.filled(hintText: 'Select school'),
              ),
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              width: AddTeacherDialog.contentWidth,
              label: 'Phone (optional)',
              child: AppTextFormField(
                controller: _phoneCtrl,
                hintText: '+91 98765 43210',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                height: AddTeacherDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              width: AddTeacherDialog.contentWidth,
              label: 'Subject (optional)',
              child: AppDropdownFormField<String>(
                items: _subjectOptions,
                value: _selectedSubject,
                onChanged: (value) =>
                    setState(() => _selectedSubject = value),
                height: AddTeacherDialog.fieldHeight,
                decoration:
                    AppFormDecorations.filled(hintText: 'Select subject'),
              ),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerRight,
              child: AppDialogActions(
                primaryLabel: widget.confirmLabel ?? 'Add',
                cancelLabel: 'Cancel',
                onPrimaryPressed: _submit,
                onCancel: () => Navigator.of(context).pop(),
                buttonSize: const Size(150, AddTeacherDialog.buttonHeight),
                primaryStyle: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shadowColor: AppColors.primary.withValues(alpha: 0.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final selectedSchool = _schoolOptions
        .firstWhere((s) => s.id == _selectedSchoolId, orElse: () => const SchoolOption(id: 0, name: ''));
    final subject = _selectedSubject?.trim();
    Navigator.of(context).pop(
      AddTeacherRequest(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        subject: subject == null || subject.isEmpty ? null : subject,
        schoolId: _selectedSchoolId,
        schoolName: selectedSchool.id == 0 ? null : selectedSchool.name,
      ),
    );
  }

  List<String> _buildSubjectOptions(List<String>? options) {
    final rawOptions = options == null || options.isEmpty
        ? _defaultSubjects
        : options;
    final unique = <String>{};
    final List<String> results = [];
    for (final option in rawOptions) {
      final trimmed = option.trim();
      if (trimmed.isEmpty || unique.contains(trimmed)) continue;
      unique.add(trimmed);
      results.add(trimmed);
    }
    return results;
  }
}
