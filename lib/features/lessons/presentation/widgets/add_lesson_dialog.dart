import 'package:ai_tutor_web/features/lessons/domain/models/lesson_plan.dart';
import 'package:ai_tutor_web/features/lessons/presentation/utils/lesson_formatters.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

Future<LessonPlan?> showAddLessonDialog({
  required BuildContext context,
  required List<String> subjects,
  required String className,
}) {
  return showDialog<LessonPlan?>(
    context: context,
    barrierDismissible: true,
    builder: (context) =>
        _AddLessonDialog(subjects: subjects, className: className),
  );
}

class _AddLessonDialog extends StatefulWidget {
  const _AddLessonDialog({required this.subjects, required this.className});

  final List<String> subjects;
  final String className;

  @override
  State<_AddLessonDialog> createState() => _AddLessonDialogState();
}

class _AddLessonDialogState extends State<_AddLessonDialog> {
  String? _selectedSubject;
  final _topicCtrl = TextEditingController();
  final _lessonCtrl = TextEditingController();
  late DateTime _selectedDate = DateTime.now();
  late TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  late TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _topicCtrl.dispose();
    _lessonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSubjects = widget.subjects.isNotEmpty;
    final subjectItems = widget.subjects
        .map(
          (subject) => DropdownMenuItem(
            value: subject,
            child: Text(subject, style: AppTypography.classCardMeta),
          ),
        )
        .toList();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double maxWidth = constraints.maxWidth;
                final bool isCompact = maxWidth < 520;
                double fieldWidth(double desired) =>
                    isCompact ? maxWidth : desired;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'New Lesson',
                        style: AppTypography.dashboardTitle.copyWith(
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _DialogField(
                          width: fieldWidth(250),
                          label: 'Subject',
                          child: DropdownButtonFormField<String>(
                            value: hasSubjects ? _selectedSubject : null,
                            items: subjectItems,
                            onChanged: hasSubjects
                                ? (value) =>
                                      setState(() => _selectedSubject = value)
                                : null,
                            validator: (value) {
                              if (!hasSubjects) return 'No subjects available';
                              if (value == null || value.isEmpty)
                                return 'Select a subject';
                              return null;
                            },
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.textPrimary,
                            ),
                            decoration: _fieldDecoration(
                              hint: hasSubjects ? 'Select Subject' : null,
                            ),
                            style: AppTypography.classCardMeta.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            hint: Text(
                              'Select Subject',
                              style: AppTypography.classCardMeta.copyWith(
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                        _DialogField(
                          width: fieldWidth(250),
                          label: 'Topic',
                          child: TextFormField(
                            controller: _topicCtrl,
                            decoration: _fieldDecoration(
                              hint: 'Enter your Topic',
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty)
                                return 'Enter a topic';
                              return null;
                            },
                          ),
                        ),
                        _DialogField(
                          width: fieldWidth(517),
                          label: 'Lesson',
                          child: TextFormField(
                            controller: _lessonCtrl,
                            decoration: _fieldDecoration(
                              hint: 'Enter your Lesson Title',
                            ),
                            validator: (value) {
                              if ((value ?? '').trim().isEmpty)
                                return 'Enter a lesson title';
                              return null;
                            },
                          ),
                        ),
                        _DialogField(
                          width: fieldWidth(159),
                          label: 'Date',
                          child: _PickerButton(
                            value: formatLessonDate(_selectedDate),
                            icon: Icons.calendar_today,
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              if (picked != null) {
                                setState(() => _selectedDate = picked);
                              }
                            },
                          ),
                        ),
                        _DialogField(
                          width: fieldWidth(159),
                          label: 'Start Time',
                          child: _PickerButton(
                            value: formatLessonTime(_startTime),
                            icon: Icons.access_time,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _startTime,
                              );
                              if (picked != null) {
                                setState(() => _startTime = picked);
                              }
                            },
                          ),
                        ),
                        _DialogField(
                          width: fieldWidth(159),
                          label: 'End Time',
                          child: _PickerButton(
                            value: formatLessonTime(_endTime),
                            icon: Icons.access_time,
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: _endTime,
                              );
                              if (picked != null) {
                                setState(() => _endTime = picked);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 163,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.studentsFilterBorder,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: AppTypography.button.copyWith(
                                color: AppColors.primary,
                              ),
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        SizedBox(
                          width: 163,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: AppTypography.button,
                            ),
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.studentsFilterBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.studentsFilterBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;
    final subject = _selectedSubject;
    if (subject == null || subject.isEmpty) return;
    final lesson = LessonPlan(
      date: _selectedDate,
      className: widget.className,
      subject: subject,
      topic: _topicCtrl.text.trim(),
      description: _lessonCtrl.text.trim(),
      startTime: _startTime,
      endTime: _endTime,
      status: LessonStatus.pending,
    );
    Navigator.of(context).pop(lesson);
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({this.width, required this.label, required this.child});

  final double? width;
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.classCardMeta.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(height: 56, child: child),
      ],
    );

    if (width != null) {
      return SizedBox(width: width, child: content);
    }
    return content;
  }
}

class _PickerButton extends StatelessWidget {
  const _PickerButton({
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.studentsFilterBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      icon: Icon(icon, size: 18, color: AppColors.iconMuted),
      label: Align(
        alignment: Alignment.centerLeft,
        child: Text(value, style: AppTypography.classCardMeta),
      ),
    );
  }
}
