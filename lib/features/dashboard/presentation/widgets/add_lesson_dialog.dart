import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
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
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(
          width: AddLessonDialog.dialogWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'New Lesson',
                    style: AppTypography.sectionTitle.copyWith(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: AddLessonDialog.splitFieldWidth,
                      child: _DropdownField(
                        label: 'Subject',
                        value: _subject,
                        options: widget.subjectOptions,
                        onChanged: (value) => setState(() => _subject = value),
                      ),
                    ),
                    SizedBox(
                      width: AddLessonDialog.splitFieldWidth,
                      child: _TextField(
                        label: 'Topic',
                        controller: _topicController,
                        hintText: 'Enter your Topic',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Topic is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: AddLessonDialog.contentWidth,
                  child: _TextField(
                    label: 'Lesson',
                    controller: _lessonController,
                    hintText: 'Enter your Lesson Title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Lesson title is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: AddLessonDialog.smallFieldWidth,
                      child: _SmallDropdownField(
                        label: 'Class',
                        value: _className,
                        options: widget.classOptions,
                        onChanged: (value) =>
                            setState(() => _className = value),
                      ),
                    ),
                    SizedBox(
                      width: AddLessonDialog.smallFieldWidth,
                      child: _SmallDateField(
                        label: 'Start Date',
                        child: _DateButton(
                          date: _startDate,
                          onTap: () => _pickDate(isStart: true),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: AddLessonDialog.smallFieldWidth,
                      child: _SmallDateField(
                        label: 'End Date',
                        child: _DateButton(
                          date: _endDate,
                          onTap: () => _pickDate(isStart: false),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: AddLessonDialog.contentWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: AddLessonDialog.buttonWidth,
                        height: AddLessonDialog.buttonHeight,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
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
                        width: AddLessonDialog.buttonWidth,
                        height: AddLessonDialog.buttonHeight,
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
                          child: const Text('Add'),
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
          height: AddLessonDialog.fieldHeight,
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

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.formLabel),
        const SizedBox(height: 10),
        SizedBox(
          height: AddLessonDialog.fieldHeight,
          child: TextFormField(
            controller: controller,
            validator: validator,
            decoration: _inputDecoration(hintText),
          ),
        ),
      ],
    );
  }
}

class _SmallDateField extends StatelessWidget {
  const _SmallDateField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AddLessonDialog.smallFieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.formLabel),
          const SizedBox(height: 10),
          SizedBox(height: AddLessonDialog.fieldHeight, child: child),
        ],
      ),
    );
  }
}

class _SmallDropdownField extends StatelessWidget {
  const _SmallDropdownField({
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
    return SizedBox(
      width: AddLessonDialog.smallFieldWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.formLabel),
          const SizedBox(height: 10),
          SizedBox(
            height: AddLessonDialog.fieldHeight,
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
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String label =
        '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        side: const BorderSide(color: AppColors.studentsCardBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodySmall)),
          const Icon(
            Icons.calendar_today_outlined,
            size: 18,
            color: AppColors.iconMuted,
          ),
        ],
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
  return months[(month - 1).clamp(0, 11)];
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
