import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
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
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: SendAnnouncementDialog.dialogWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Send Announcement',
                  style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Title',
                  child: _TextField(
                    controller: _titleController,
                    hintText: 'Enter Notification Title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Message',
                  child: _MultilineField(
                    controller: _messageController,
                    hintText: 'Enter your Announcement Message...',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Message is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Recipients',
                  child: _DropdownField(
                    value: _selectedRecipient,
                    options: widget.recipientOptions,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedRecipient = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: SendAnnouncementDialog.buttonWidth,
                      height: SendAnnouncementDialog.buttonHeight,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    SizedBox(
                      width: SendAnnouncementDialog.buttonWidth,
                      height: SendAnnouncementDialog.buttonHeight,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Send'),
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
      width: SendAnnouncementDialog.contentWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.formLabel),
          const SizedBox(height: 10),
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
      height: SendAnnouncementDialog.fieldHeight,
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: _fieldDecoration(hintText),
      ),
    );
  }
}

class _MultilineField extends StatelessWidget {
  const _MultilineField({
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
      height: 135,
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLines: null,
        expands: true,
        decoration: _fieldDecoration(
          hintText,
        ).copyWith(contentPadding: const EdgeInsets.all(16)),
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

  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SendAnnouncementDialog.dropdownHeight,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        items: options
            .map(
              (option) =>
                  DropdownMenuItem<String>(value: option, child: Text(option)),
            )
            .toList(),
        onChanged: onChanged,
        decoration: _fieldDecoration(''),
      ),
    );
  }
}

InputDecoration _fieldDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
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
  );
}
