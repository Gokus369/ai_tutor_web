import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class AssignQuizRequest {
  const AssignQuizRequest({
    required this.title,
    required this.subject,
    required this.topic,
    required this.message,
    required this.assignTo,
    required this.className,
    required this.startDate,
    required this.endDate,
    required this.attachmentType,
  });

  final String title;
  final String subject;
  final String topic;
  final String message;
  final String assignTo;
  final String className;
  final DateTime startDate;
  final DateTime endDate;
  final AttachmentType attachmentType;
}

enum AttachmentType { ai, upload }

class AssignQuizDialog extends StatefulWidget {
  const AssignQuizDialog({
    super.key,
    required this.subjectOptions,
    required this.topicOptions,
    required this.assignToOptions,
    required this.classOptions,
  });

  final List<String> subjectOptions;
  final List<String> topicOptions;
  final List<String> assignToOptions;
  final List<String> classOptions;

  static const double dialogWidth = 660;
  static const double contentWidth = 517;
  static const double fieldHeight = 48;
  static const double dropdownHeight = 48;
  static const double buttonWidth = 163;
  static const double buttonHeight = 48;

  @override
  State<AssignQuizDialog> createState() => _AssignQuizDialogState();
}

class _AssignQuizDialogState extends State<AssignQuizDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _messageController;
  String? _subject;
  String? _topic;
  String? _assignTo;
  String? _className;
  DateTime _startDate = DateTime(2025, 9, 20);
  DateTime _endDate = DateTime(2025, 9, 20);
  AttachmentType? _attachmentType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _messageController = TextEditingController();
    _subject = widget.subjectOptions.isNotEmpty
        ? widget.subjectOptions.first
        : null;
    _topic = widget.topicOptions.isNotEmpty ? widget.topicOptions.first : null;
    _assignTo = widget.assignToOptions.isNotEmpty
        ? widget.assignToOptions.first
        : null;
    _className = widget.classOptions.isNotEmpty
        ? widget.classOptions.first
        : null;
    _attachmentType = AttachmentType.ai;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime now = DateTime.now();
    final DateTime first = DateTime(now.year - 1);
    final DateTime last = DateTime(now.year + 5);
    final DateTime initial = isStart ? _startDate : _endDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(picked)) {
            _endDate = picked;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_attachmentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose an attachment method')),
      );
      return;
    }

    Navigator.of(context).pop(
      AssignQuizRequest(
        title: _titleController.text.trim(),
        subject: _subject ?? '',
        topic: _topic ?? '',
        message: _messageController.text.trim(),
        assignTo: _assignTo ?? '',
        className: _className ?? '',
        startDate: _startDate,
        endDate: _endDate,
        attachmentType: _attachmentType!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: AssignQuizDialog.dialogWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Assign Quiz',
                    style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Title',
                  child: _TextField(
                    controller: _titleController,
                    hintText: 'Enter Quiz Title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                _TwoColumnRow(
                  left: _DropdownField(
                    label: 'Subject',
                    value: _subject,
                    options: widget.subjectOptions,
                    onChanged: (value) => setState(() => _subject = value),
                  ),
                  right: _DropdownField(
                    label: 'Topic',
                    value: _topic,
                    options: widget.topicOptions,
                    onChanged: (value) => setState(() => _topic = value),
                  ),
                ),
                const SizedBox(height: 24),
                _LabeledField(
                  label: 'Instructions (Optional)',
                  child: _MultilineField(
                    controller: _messageController,
                    hintText: 'e.g: Complete within 10 days.',
                  ),
                ),
                const SizedBox(height: 24),
                _TwoColumnRow(
                  left: _DropdownField(
                    label: 'Assign To',
                    value: _assignTo,
                    options: widget.assignToOptions,
                    onChanged: (value) => setState(() => _assignTo = value),
                  ),
                  right: _DropdownField(
                    label: 'Class',
                    value: _className,
                    options: widget.classOptions,
                    onChanged: (value) => setState(() => _className = value),
                  ),
                ),
                const SizedBox(height: 24),
                _TwoColumnRow(
                  left: _DatePickerField(
                    label: 'Start Date',
                    date: _startDate,
                    onTap: () => _pickDate(isStart: true),
                  ),
                  right: _DatePickerField(
                    label: 'End Date',
                    date: _endDate,
                    onTap: () => _pickDate(isStart: false),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: AssignQuizDialog.contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attach Questions',
                        style: AppTypography.sectionTitle.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _AttachmentCard(
                              label: 'Generate via AI',
                              icon: Icons.auto_awesome,
                              selected: _attachmentType == AttachmentType.ai,
                              onTap: () => setState(
                                () => _attachmentType = AttachmentType.ai,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _AttachmentCard(
                              label: 'Upload File',
                              icon: Icons.upload_file,
                              selected:
                                  _attachmentType == AttachmentType.upload,
                              onTap: () => setState(
                                () => _attachmentType = AttachmentType.upload,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: AssignQuizDialog.contentWidth,
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    alignment: WrapAlignment.start,
                    children: [
                      SizedBox(
                        width: AssignQuizDialog.buttonWidth,
                        height: AssignQuizDialog.buttonHeight,
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
                        width: AssignQuizDialog.buttonWidth,
                        height: AssignQuizDialog.buttonHeight,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Assign'),
                        ),
                      ),
                    ],
                  ),
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
      width: AssignQuizDialog.contentWidth,
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

class _TwoColumnRow extends StatelessWidget {
  const _TwoColumnRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AssignQuizDialog.contentWidth,
      child: Row(
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
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
      height: AssignQuizDialog.fieldHeight,
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: _inputDecoration(hintText),
      ),
    );
  }
}

class _MultilineField extends StatelessWidget {
  const _MultilineField({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: TextFormField(
        controller: controller,
        maxLines: null,
        expands: true,
        decoration: _inputDecoration(
          hintText,
        ).copyWith(contentPadding: const EdgeInsets.all(16)),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.formLabel),
        const SizedBox(height: 10),
        SizedBox(
          height: AssignQuizDialog.dropdownHeight,
          child: DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            items: options
                .map(
                  (option) =>
                      DropdownMenuItem(value: option, child: Text(option)),
                )
                .toList(),
            onChanged: onChanged,
            decoration: _inputDecoration(''),
          ),
        ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.formLabel),
        const SizedBox(height: 10),
        SizedBox(
          height: AssignQuizDialog.fieldHeight,
          child: OutlinedButton(
            onPressed: onTap,
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
                Text(formatted, style: AppTypography.bodySmall),
                const Spacer(),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.iconMuted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AttachmentCard extends StatelessWidget {
  const _AttachmentCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = selected
        ? AppColors.primary
        : AppColors.studentsCardBorder;
    final Color foreground = selected
        ? AppColors.primary
        : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: foreground, size: 26),
            const SizedBox(height: 10),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

InputDecoration _inputDecoration(String hint) {
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
