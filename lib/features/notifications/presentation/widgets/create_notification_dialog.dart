import 'package:ai_tutor_web/features/notifications/domain/models/notification_item.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class CreateNotificationDialog extends StatefulWidget {
  const CreateNotificationDialog({
    super.key,
    required this.recipientOptions,
    this.initialType = NotificationType.assignment,
    this.initialRecipient,
  });

  final List<String> recipientOptions;
  final NotificationType initialType;
  final String? initialRecipient;

  static const double _dialogWidth = 621;
  static const double _titleWidth = 222;
  static const double _inputWidth = 517;
  static const double _inputHeight = 69;
  static const double _messageHeight = 135;
  static const double _halfInputWidth = 250;
  static const double _buttonWidth = 163;
  static const double _buttonHeight = 50;

  @override
  State<CreateNotificationDialog> createState() =>
      _CreateNotificationDialogState();
}

class _CreateNotificationDialogState extends State<CreateNotificationDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  late NotificationType _selectedType;
  late String _selectedRecipient;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();
    _selectedType = widget.initialType;
    _selectedRecipient = widget.initialRecipient ??
        (widget.recipientOptions.isNotEmpty
            ? widget.recipientOptions.first
            : '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleCancel() => Navigator.of(context).pop();

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateNotificationRequest(
      title: _titleController.text.trim(),
      message: _messageController.text.trim(),
      type: _selectedType,
      recipient: _selectedRecipient,
    );

    Navigator.of(context).pop(request);
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets contentPadding =
        const EdgeInsets.symmetric(horizontal: 52, vertical: 36);

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints:
            const BoxConstraints.tightFor(width: CreateNotificationDialog._dialogWidth),
        child: Padding(
          padding: contentPadding,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: CreateNotificationDialog._titleWidth,
                  child: Text(
                    'Create Notifications',
                    style: AppTypography.sectionTitle,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 28),
                _LabeledField(
                  label: 'Title',
                  child: _SizedField(
                    width: CreateNotificationDialog._inputWidth,
                    height: CreateNotificationDialog._inputHeight,
                    child: TextFormField(
                      controller: _titleController,
                      validator: _nonEmptyValidator,
                      decoration: _inputDecoration('Enter Notification Title'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _LabeledField(
                  label: 'Message',
                  child: _SizedField(
                    width: CreateNotificationDialog._inputWidth,
                    height: CreateNotificationDialog._messageHeight,
                    child: TextFormField(
                      controller: _messageController,
                      validator: _nonEmptyValidator,
                      maxLines: null,
                      expands: true,
                      decoration: _inputDecoration('Enter Notification Message')
                          .copyWith(contentPadding: const EdgeInsets.all(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: CreateNotificationDialog._inputWidth,
                  height: CreateNotificationDialog._messageHeight,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: CreateNotificationDialog._halfInputWidth,
                        child: _LabeledField(
                          label: 'Category',
                          child: _SizedField(
                            width: CreateNotificationDialog._halfInputWidth,
                            height: CreateNotificationDialog._inputHeight,
                            child: DropdownButtonFormField<NotificationType>(
                              key: ValueKey(_selectedType),
                              initialValue: _selectedType,
                              decoration: _inputDecoration(null).copyWith(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              items: NotificationType.values
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedType = value);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 17),
                      SizedBox(
                        width: CreateNotificationDialog._halfInputWidth,
                        child: _LabeledField(
                          label: 'Recipients',
                          child: _SizedField(
                            width: CreateNotificationDialog._halfInputWidth,
                            height: CreateNotificationDialog._inputHeight,
                            child: DropdownButtonFormField<String>(
                              key: ValueKey(_selectedRecipient),
                              initialValue: _selectedRecipient,
                              decoration: _inputDecoration(null).copyWith(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 20,
                                ),
                              ),
                              items: widget.recipientOptions
                                  .map(
                                    (recipient) => DropdownMenuItem(
                                      value: recipient,
                                      child: Text(recipient),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedRecipient = value);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SizedField(
                      width: CreateNotificationDialog._buttonWidth,
                      height: CreateNotificationDialog._buttonHeight,
                      child: OutlinedButton(
                        onPressed: _handleCancel,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    _SizedField(
                      width: CreateNotificationDialog._buttonWidth,
                      height: CreateNotificationDialog._buttonHeight,
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Send Now'),
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

  String? _nonEmptyValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  InputDecoration _inputDecoration(String? hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
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
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

class CreateNotificationRequest {
  const CreateNotificationRequest({
    required this.title,
    required this.message,
    required this.type,
    required this.recipient,
  });

  final String title;
  final String message;
  final NotificationType type;
  final String recipient;
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.formLabel,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _SizedField extends StatelessWidget {
  const _SizedField({
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}
