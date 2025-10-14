import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';

class ProgressDemoData {
  ProgressDemoData._();

  static ProgressPageData build() {
    return ProgressPageData(
      classOptions: const ['Class 10', 'Class 9', 'Class 8'],
      initialClass: 'Class 10',
      summary: const ProgressSummary(modules: 24, students: 76),
      mathematics: SubjectDetail(
        name: 'Mathematics',
        status: SubjectStatus.inProgress,
        focusArea: 'Linear Equations',
        collapsedModules: const ['Geometry', 'Algebra'],
        chapters: const [
          ChapterProgress(
            title: 'Chapter 1: Linear Equations (10/15 Topics)',
            progress: 0.62,
            progressLabel: '62%',
          ),
          ChapterProgress(
            title: 'Chapter 2: Function & Graphs (5/8 Topics)',
            progress: 0.46,
            progressLabel: '46%',
          ),
          ChapterProgress(
            title: 'Chapter 3: Variables and Constants (5/10 Topics)',
            progress: 0.77,
            progressLabel: '77%',
          ),
        ],
      ),
      additionalSubjects: const [
        SubjectSummary(name: 'Physics', status: SubjectStatus.inProgress),
        SubjectSummary(name: 'English', status: SubjectStatus.inProgress),
        SubjectSummary(name: 'Social Science', status: SubjectStatus.completed),
      ],
      students: const [
        StudentProgress(name: 'Rowan Hahn', progress: 0.85),
        StudentProgress(name: 'Giovanni Fields', progress: 0.46, alert: StudentAlert(label: 'Struggling in Science', type: StudentAlertType.warning)),
        StudentProgress(name: 'Rowen Holland', progress: 0.58),
        StudentProgress(name: 'Celeste Moore', progress: 0.52),
        StudentProgress(name: 'Matteo Nelson', progress: 0.79, alert: StudentAlert(label: 'Struggling in Maths', type: StudentAlertType.warning)),
        StudentProgress(name: 'Elise Gill', progress: 0.30, alert: StudentAlert(label: 'Low Performance', type: StudentAlertType.danger)),
        StudentProgress(name: 'Gerardo Dillon', progress: 0.33),
      ],
    );
  }
}
