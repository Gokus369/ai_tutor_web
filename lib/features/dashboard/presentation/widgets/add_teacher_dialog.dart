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
  });

  final String name;
  final String email;
  final String? phone;
  final String? subject;
}

class AddTeacherDialog extends StatefulWidget {
  const AddTeacherDialog({super.key});

  static const double dialogWidth = 620;
  static const double contentWidth = 520;
  static const double fieldHeight = 56;
  static const double buttonHeight = 48;

  @override
  State<AddTeacherDialog> createState() => _AddTeacherDialogState();
}

class _AddTeacherDialogState extends State<AddTeacherDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _subjectCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _subjectCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: 'Add Teacher',
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
                validator: (v) {
                  final trimmed = (v ?? '').trim();
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
              child: AppTextFormField(
                controller: _subjectCtrl,
                hintText: 'Mathematics',
                textInputAction: TextInputAction.done,
                height: AddTeacherDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerRight,
              child: AppDialogActions(
                primaryLabel: 'Add',
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
    Navigator.of(context).pop(
      AddTeacherRequest(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        subject: _subjectCtrl.text.trim().isEmpty ? null : _subjectCtrl.text.trim(),
      ),
    );
  }
}
