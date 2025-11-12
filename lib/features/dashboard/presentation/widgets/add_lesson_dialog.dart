import 'package:ai_tutor_web/shared/widgets/app_dialog_shell.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
import 'package:flutter/material.dart';

class AddLessonRequest {
  const AddLessonRequest({
    required this.subject,
    required this.topic,
    required this.lessonTitle,
    required this.className,
    required this.startDate,
    required this.endDate,
  });

  final String subject;
  final String topic;
  final String lessonTitle;
  final String className;
  final DateTime startDate;
  final DateTime endDate;
}

class AddLessonDialog extends StatefulWidget {
  const AddLessonDialog({
    super.key,
    required this.subjectOptions,
    required this.classOptions,
  });

  final List<String> subjectOptions;
  final List<String> classOptions;

  static const double dialogWidth = 620;
  static const double contentWidth = 517;
  static const double fieldHeight = 69;
  static const double splitFieldWidth = 250;
  static const double smallFieldWidth = 159;
  static const double buttonWidth = 163;
  static const double buttonHeight = 48;

  @override
  State<AddLessonDialog> createState() => _AddLessonDialogState();
}

class _AddLessonDialogState extends State<AddLessonDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _topicController;
  late final TextEditingController _lessonController;
  String? _subject;
  String? _className;
  DateTime _startDate = DateTime(2025, 8, 23);
  DateTime _endDate = DateTime(2025, 8, 23);

  @override
  void initState() {
    super.initState();
    _topicController = TextEditingController();
    _lessonController = TextEditingController();
    _subject = widget.subjectOptions.isNotEmpty
        ? widget.subjectOptions.first
        : null;
    _className = widget.classOptions.isNotEmpty
        ? widget.classOptions.first
        : null;
  }

  @override
  void dispose() {
    _topicController.dispose();
    _lessonController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime initial = isStart ? _startDate : _endDate;
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
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

    Navigator.of(context).pop(
      AddLessonRequest(
        subject: _subject ?? '',
        topic: _topicController.text.trim(),
        lessonTitle: _lessonController.text.trim(),
        className: _className ?? '',
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogShell(
      title: 'New Lesson',
      width: AddLessonDialog.dialogWidth,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AddLessonDialog.contentWidth,
              child: Row(
                children: [
                  AppLabeledField(
                    width: AddLessonDialog.splitFieldWidth,
                    label: 'Subject',
                    child: AppDropdownFormField<String>(
                      items: widget.subjectOptions,
                      value: _subject,
                      onChanged: (value) => setState(() => _subject = value),
                      height: AddLessonDialog.fieldHeight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AppLabeledField(
                    width: AddLessonDialog.splitFieldWidth,
                    label: 'Topic',
                    child: AppTextFormField(
                      controller: _topicController,
                      hintText: 'Enter your Topic',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Topic is required';
                        }
                        return null;
                      },
                      height: AddLessonDialog.fieldHeight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppLabeledField(
              width: AddLessonDialog.contentWidth,
              label: 'Lesson',
              child: AppTextFormField(
                controller: _lessonController,
                hintText: 'Enter your Lesson Title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Lesson title is required';
                  }
                  return null;
                },
                height: AddLessonDialog.fieldHeight,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: AddLessonDialog.contentWidth,
              child: Row(
                children: [
                  AppLabeledField(
                    width: AddLessonDialog.smallFieldWidth,
                    label: 'Class',
                    child: AppDropdownFormField<String>(
                      items: widget.classOptions,
                      value: _className,
                      onChanged: (value) => setState(() => _className = value),
                      height: AddLessonDialog.fieldHeight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AppLabeledField(
                    width: AddLessonDialog.smallFieldWidth,
                    label: 'Start Date',
                    child: AppDateButton(
                      label: formatCompactDate(_startDate),
                      onTap: () => _pickDate(isStart: true),
                      height: AddLessonDialog.fieldHeight,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AppLabeledField(
                    width: AddLessonDialog.smallFieldWidth,
                    label: 'End Date',
                    child: AppDateButton(
                      label: formatCompactDate(_endDate),
                      onTap: () => _pickDate(isStart: false),
                      height: AddLessonDialog.fieldHeight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: AddLessonDialog.contentWidth,
              child: AppDialogActions(
                primaryLabel: 'Add',
                onPrimaryPressed: _submit,
                onCancel: () => Navigator.of(context).pop(false),
                buttonSize: const Size(
                  AddLessonDialog.buttonWidth,
                  AddLessonDialog.buttonHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
