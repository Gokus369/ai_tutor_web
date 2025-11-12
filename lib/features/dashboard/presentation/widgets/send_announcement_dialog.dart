import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/widgets/app_dialog_shell.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
import 'package:flutter/material.dart';

class SendAnnouncementRequest {
  const SendAnnouncementRequest({
    required this.title,
    required this.message,
    required this.recipient,
  });

  final String title;
  final String message;
  final String recipient;
}

class SendAnnouncementDialog extends StatefulWidget {
  const SendAnnouncementDialog({super.key, required this.recipientOptions});

  final List<String> recipientOptions;

  static const double dialogWidth = 620;
  static const double contentWidth = 517;
  static const double fieldHeight = 69;
  static const double dropdownHeight = 69;
  static const double buttonWidth = 163;
  static const double buttonHeight = 48;

  @override
  State<SendAnnouncementDialog> createState() => _SendAnnouncementDialogState();
}

class _SendAnnouncementDialogState extends State<SendAnnouncementDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  late String _selectedRecipient;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();
    _selectedRecipient = widget.recipientOptions.isNotEmpty
        ? widget.recipientOptions.first
        : 'All Students';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).pop(
      SendAnnouncementRequest(
        title: _titleController.text.trim(),
        message: _messageController.text.trim(),
        recipient: _selectedRecipient,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: 'Send Announcement',
      width: SendAnnouncementDialog.dialogWidth,
      crossAxisAlignment: CrossAxisAlignment.center,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppLabeledField(
              width: SendAnnouncementDialog.contentWidth,
              label: 'Title',
              child: AppTextFormField(
                controller: _titleController,
                hintText: 'Enter Notification Title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                height: SendAnnouncementDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: SendAnnouncementDialog.contentWidth,
              label: 'Message',
              child: AppTextFormField(
                controller: _messageController,
                hintText: 'Enter your Announcement Message...',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Message is required';
                  }
                  return null;
                },
                height: 135,
                expands: true,
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: SendAnnouncementDialog.contentWidth,
              label: 'Recipients',
              child: AppDropdownFormField<String>(
                items: widget.recipientOptions,
                value: _selectedRecipient,
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedRecipient = value);
                  }
                },
                height: SendAnnouncementDialog.dropdownHeight,
              ),
            ),
            const SizedBox(height: 24),
            const Divider(
              height: 32,
              thickness: 1,
              color: AppColors.studentsCardBorder,
            ),
            const SizedBox(height: 8),
            AppDialogActions(
              primaryLabel: 'Send',
              onPrimaryPressed: _handleSubmit,
              onCancel: () => Navigator.of(context).pop(),
              buttonSize: const Size(
                SendAnnouncementDialog.buttonWidth,
                SendAnnouncementDialog.buttonHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
