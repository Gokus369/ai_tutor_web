import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_progress.dart';
import 'package:ai_tutor_web/features/syllabus/domain/models/syllabus_subject.dart';
import 'package:ai_tutor_web/features/syllabus/presentation/widgets/syllabus_view.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/widgets/app_form_fields.dart';
import 'package:flutter/material.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  int _expandedIndex = 0;

  static final List<SyllabusSubject> _seedSubjects = [
    SyllabusSubject(
      title: 'Mathematics',
      status: SyllabusStatus.inProgress,
      modules: const [
        SyllabusModule(
          title: 'Linear Equations',
          completionPercentage: 0.62,
          topicSummary: 'Chapter 1: Linear Equations (10/15 Topics)',
        ),
        SyllabusModule(
          title: 'Chapter 2: Function & Graphs',
          completionPercentage: 0.46,
          topicSummary: 'Chapter 2: Function & Graphs (5/8 Topics)',
        ),
        SyllabusModule(
          title: 'Chapter 3: Variables and Constants',
          completionPercentage: 0.77,
          topicSummary: 'Chapter 3: Variables & Constants (5/10 Topics)',
        ),
      ],
      additionalTopics: const ['Geometry', 'Algebra'],
    ),
    SyllabusSubject(
      title: 'Physics',
      status: SyllabusStatus.inProgress,
      modules: const [
        SyllabusModule(
          title: 'Motion and Force',
          completionPercentage: 0.58,
          topicSummary: 'Chapter 1: Motion Basics (7/12 Topics)',
        ),
        SyllabusModule(
          title: 'Electricity Fundamentals',
          completionPercentage: 0.31,
          topicSummary: 'Chapter 2: Electrostatics (4/13 Topics)',
        ),
      ],
      additionalTopics: const ['Sound Waves'],
    ),
    SyllabusSubject(
      title: 'English',
      status: SyllabusStatus.inProgress,
      modules: const [
        SyllabusModule(
          title: 'Literature & Comprehension',
          completionPercentage: 0.54,
          topicSummary: 'Chapter 1: Poetry (6/11 Topics)',
        ),
      ],
      additionalTopics: const ['Writing Skills'],
    ),
    SyllabusSubject(
      title: 'Social Science',
      status: SyllabusStatus.completed,
      modules: const [
        SyllabusModule(
          title: 'History & Civics',
          completionPercentage: 1.0,
          topicSummary: 'Chapter 4: Indian Constitution (12/12 Topics)',
        ),
      ],
      additionalTopics: const ['Economics'],
    ),
  ];

  static final List<SyllabusProgress> _seedProgressEntries = const [
    SyllabusProgress(subject: 'Mathematics', completionPercentage: 0.73),
    SyllabusProgress(subject: 'Physics', completionPercentage: 0.58),
    SyllabusProgress(subject: 'Biology', completionPercentage: 0.69),
    SyllabusProgress(subject: 'Chemistry', completionPercentage: 0.87),
    SyllabusProgress(subject: 'English', completionPercentage: 0.81),
    SyllabusProgress(subject: 'Social Science', completionPercentage: 0.44),
  ];

  List<SyllabusSubject> _subjects = List<SyllabusSubject>.from(_seedSubjects);
  List<SyllabusProgress> _progressEntries =
      List<SyllabusProgress>.from(_seedProgressEntries);

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.syllabus,
      title: 'Syllabus',
      titleSpacing: 20,
      builder: (context, shell) {
        return SyllabusView(
          subjects: _subjects,
          progressEntries: _progressEntries,
          expandedIndex: _expandedIndex,
          onAddSubject: _openAddSubjectDialog,
          onSubjectToggle: (index) {
            setState(() {
              _expandedIndex = index == _expandedIndex ? -1 : index;
            });
          },
        );
      },
    );
  }

  Future<void> _openAddSubjectDialog() async {
    final result = await showDialog<_NewSubjectData>(
      context: context,
      builder: (_) => const _AddSubjectDialog(),
    );
    if (result == null) return;
    setState(() {
      final newSubject = SyllabusSubject(
        title: result.title,
        status: result.status,
        modules: const [],
        additionalTopics: const [],
      );
      _subjects = [newSubject, ..._subjects];
      _progressEntries = [
        SyllabusProgress(
          subject: result.title,
          completionPercentage: 0,
        ),
        ..._progressEntries,
      ];
      _expandedIndex = 0;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Subject "${result.title}" added')),
    );
  }
}

class _AddSubjectDialog extends StatefulWidget {
  const _AddSubjectDialog();

  @override
  State<_AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<_AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  SyllabusStatus _status = SyllabusStatus.inProgress;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Subject',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, size: 20),
                      splashRadius: 20,
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Subject name',
                    hintText: 'e.g., Biology',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) => (v ?? '').trim().isEmpty ? 'Enter a subject' : null,
                ),
                const SizedBox(height: 16),
                AppLabeledField(
                  label: 'Status',
                  spacing: 8,
                  child: AppDropdownFormField<SyllabusStatus>(
                    value: _status,
                    onChanged: (value) => setState(() => _status = value ?? _status),
                    items: const [
                      SyllabusStatus.inProgress,
                      SyllabusStatus.completed,
                    ],
                    itemBuilder: (status) => Text(
                      status == SyllabusStatus.completed ? 'Completed' : 'In progress',
                    ),
                    decoration: AppFormDecorations.filled(),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Add'),
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

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      _NewSubjectData(
        title: _titleCtrl.text.trim(),
        status: _status,
      ),
    );
  }
}

class _NewSubjectData {
  const _NewSubjectData({required this.title, required this.status});
  final String title;
  final SyllabusStatus status;
}
