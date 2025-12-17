import 'package:ai_tutor_web/features/schools/domain/models/add_school_request.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/widgets/app_dialog_shell.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
import 'package:flutter/material.dart';

class AddSchoolDialog extends StatefulWidget {
  const AddSchoolDialog({super.key, this.initial, this.title, this.confirmLabel});

  static const double dialogWidth = 680;
  static const double contentWidth = 620;
  static const double fieldHeight = 56;
  static const double buttonHeight = 48;

  final AddSchoolRequest? initial;
  final String? title;
  final String? confirmLabel;

  @override
  State<AddSchoolDialog> createState() => _AddSchoolDialogState();
}

class _AddSchoolDialogState extends State<AddSchoolDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _principalCtrl = TextEditingController();
  final _createdByCtrl = TextEditingController();
  int? _selectedBoardId;

  static const List<_BoardOption> _boardOptions = [
    _BoardOption(id: 1, label: 'CBSE'),
    _BoardOption(id: 2, label: 'ICSE'),
    _BoardOption(id: 3, label: 'State Board'),
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _nameCtrl.text = initial.schoolName;
      _addressCtrl.text = initial.address;
      _codeCtrl.text = initial.code;
      _selectedBoardId = _boardOptions
          .map((option) => option.id)
          .contains(initial.boardId)
          ? initial.boardId
          : _boardOptions.first.id;
      if (initial.principalId != null) {
        _principalCtrl.text = initial.principalId.toString();
      }
      if (initial.createdById != null) {
        _createdByCtrl.text = initial.createdById.toString();
      }
    } else {
      _selectedBoardId = _boardOptions.first.id;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _codeCtrl.dispose();
    _principalCtrl.dispose();
    _createdByCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: widget.title ?? 'Add School',
      width: AddSchoolDialog.dialogWidth,
      insetPadding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLabeledField(
              width: AddSchoolDialog.contentWidth,
              label: 'School name',
              child: AppTextFormField(
                controller: _nameCtrl,
                hintText: 'Sunshine Public School',
                textInputAction: TextInputAction.next,
                validator: (v) => (v ?? '').trim().isEmpty ? 'Enter a school name' : null,
                height: AddSchoolDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              width: AddSchoolDialog.contentWidth,
              label: 'Address',
              child: AppTextFormField(
                controller: _addressCtrl,
                hintText: '456 Park Avenue, Mumbai',
                textInputAction: TextInputAction.next,
                validator: (v) => (v ?? '').trim().isEmpty ? 'Enter an address' : null,
                height: AddSchoolDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppLabeledField(
                    label: 'Code',
                    child: AppTextFormField(
                      controller: _codeCtrl,
                      hintText: 'SPS001',
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v ?? '').trim().isEmpty ? 'Enter a code' : null,
                      height: AddSchoolDialog.fieldHeight,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppLabeledField(
                    label: 'Board',
                    child: AppDropdownFormField<int>(
                      items: _boardOptions.map((option) => option.id).toList(),
                      value: _selectedBoardId,
                      itemBuilder: (id) => Text(
                        _boardOptions.firstWhere((option) => option.id == id).label,
                      ),
                      onChanged: (value) =>
                          setState(() => _selectedBoardId = value),
                      validator: (value) =>
                          value == null ? 'Select a board' : null,
                      height: AddSchoolDialog.fieldHeight,
                      decoration:
                          AppFormDecorations.filled(hintText: 'Select board'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              width: AddSchoolDialog.contentWidth,
              label: 'Created by (optional)',
              child: AppTextFormField(
                controller: _createdByCtrl,
                hintText: 'Admin user ID',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  final trimmed = (v ?? '').trim();
                  if (trimmed.isEmpty) return null;
                  if (int.tryParse(trimmed) == null) {
                    return 'Must be a number';
                  }
                  return null;
                },
                height: AddSchoolDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 20),
            AppLabeledField(
              width: AddSchoolDialog.contentWidth,
              label: 'Principal ID (optional)',
              child: AppTextFormField(
                controller: _principalCtrl,
                hintText: 'Principal user ID',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  final trimmed = (v ?? '').trim();
                  if (trimmed.isEmpty) return null;
                  if (int.tryParse(trimmed) == null) {
                    return 'Must be a number';
                  }
                  return null;
                },
                height: AddSchoolDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerRight,
              child: AppDialogActions(
                primaryLabel: widget.confirmLabel ?? 'Add',
                cancelLabel: 'Cancel',
                onPrimaryPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  final boardId = _selectedBoardId ?? _boardOptions.first.id;
                  final createdByText = _createdByCtrl.text.trim();
                  final principalText = _principalCtrl.text.trim();
                  final createdById = createdByText.isEmpty ? null : int.tryParse(createdByText);
                  final principalId = principalText.isEmpty ? null : int.tryParse(principalText);
                  Navigator.of(context).pop(
                    AddSchoolRequest(
                      schoolName: _nameCtrl.text.trim(),
                      address: _addressCtrl.text.trim(),
                      code: _codeCtrl.text.trim(),
                      boardId: boardId,
                      principalId: principalId,
                      createdById: createdById,
                    ),
                  );
                },
                onCancel: () => Navigator.of(context).pop(),
                buttonSize: const Size(150, AddSchoolDialog.buttonHeight),
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
}

class _BoardOption {
  const _BoardOption({required this.id, required this.label});

  final int id;
  final String label;
}
