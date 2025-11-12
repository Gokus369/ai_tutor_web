import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:ai_tutor_web/shared/widgets/app_dialog_shell.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
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
    return AppDialogShell(
      title: 'Assign Quiz',
      width: AssignQuizDialog.dialogWidth,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLabeledField(
              width: AssignQuizDialog.contentWidth,
              label: 'Title',
              child: AppTextFormField(
                controller: _titleController,
                hintText: 'Enter Quiz Title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
                height: AssignQuizDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 24),
            _TwoColumnRow(
              left: AppLabeledField(
                label: 'Subject',
                child: AppDropdownFormField<String>(
                  items: widget.subjectOptions,
                  value: _subject,
                  onChanged: (value) => setState(() => _subject = value),
                  height: AssignQuizDialog.dropdownHeight,
                ),
              ),
              right: AppLabeledField(
                label: 'Topic',
                child: AppDropdownFormField<String>(
                  items: widget.topicOptions,
                  value: _topic,
                  onChanged: (value) => setState(() => _topic = value),
                  height: AssignQuizDialog.dropdownHeight,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: AssignQuizDialog.contentWidth,
              label: 'Instructions (Optional)',
              child: AppTextFormField(
                controller: _messageController,
                hintText: 'e.g: Complete within 10 days.',
                height: 104,
                expands: true,
              ),
            ),
            const SizedBox(height: 24),
            _TwoColumnRow(
              left: AppLabeledField(
                label: 'Assign To',
                child: AppDropdownFormField<String>(
                  items: widget.assignToOptions,
                  value: _assignTo,
                  onChanged: (value) => setState(() => _assignTo = value),
                  height: AssignQuizDialog.dropdownHeight,
                ),
              ),
              right: AppLabeledField(
                label: 'Class',
                child: AppDropdownFormField<String>(
                  items: widget.classOptions,
                  value: _className,
                  onChanged: (value) => setState(() => _className = value),
                  height: AssignQuizDialog.dropdownHeight,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _TwoColumnRow(
              left: AppLabeledField(
                label: 'Start Date',
                child: AppDateButton(
                  label: formatCompactDate(_startDate),
                  onTap: () => _pickDate(isStart: true),
                  height: AssignQuizDialog.fieldHeight,
                ),
              ),
              right: AppLabeledField(
                label: 'End Date',
                child: AppDateButton(
                  label: formatCompactDate(_endDate),
                  onTap: () => _pickDate(isStart: false),
                  height: AssignQuizDialog.fieldHeight,
                ),
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
                    style: AppTypography.sectionTitle.copyWith(fontSize: 18),
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
                          icon: Icons.file_upload_outlined,
                          selected: _attachmentType == AttachmentType.upload,
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
              child: AppDialogActions(
                primaryLabel: 'Assign',
                onPrimaryPressed: _submit,
                onCancel: () => Navigator.of(context).pop(),
                buttonSize: const Size(
                  AssignQuizDialog.buttonWidth,
                  AssignQuizDialog.buttonHeight,
                ),
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
          ],
        ),
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
