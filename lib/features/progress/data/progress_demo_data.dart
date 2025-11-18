import 'package:ai_tutor_web/features/progress/domain/models/progress_models.dart';

class ProgressDemoData {
  ProgressDemoData._();

  static ProgressPageData build() {
    const classes = ['Class 10', 'Class 9', 'Class 8'];
    return ProgressPageData(
      classOptions: classes,
      initialClass: classes.first,
      classes: {
        'Class 10': _class10(),
        'Class 9': _class9(),
        'Class 8': _class8(),
      },
    );
  }

  static ClassProgressData _class10() {
    return ClassProgressData(
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

  static ClassProgressData _class9() {
    return ClassProgressData(
      summary: const ProgressSummary(modules: 18, students: 68),
      mathematics: SubjectDetail(
        name: 'Mathematics',
        status: SubjectStatus.inProgress,
        focusArea: 'Quadratic Equations',
        collapsedModules: const ['Probability', 'Mensuration'],
        chapters: const [
          ChapterProgress(
            title: 'Chapter 1: Quadratics (6/12 Topics)',
            progress: 0.50,
            progressLabel: '50%',
          ),
          ChapterProgress(
            title: 'Chapter 2: Trigonometry (4/10 Topics)',
            progress: 0.40,
            progressLabel: '40%',
          ),
          ChapterProgress(
            title: 'Chapter 3: Coordinate Geometry (7/12 Topics)',
            progress: 0.58,
            progressLabel: '58%',
          ),
        ],
      ),
      additionalSubjects: const [
        SubjectSummary(name: 'Physics', status: SubjectStatus.inProgress),
        SubjectSummary(name: 'Biology', status: SubjectStatus.inProgress),
        SubjectSummary(name: 'Geography', status: SubjectStatus.completed),
      ],
      students: const [
        StudentProgress(name: 'Joy Keller', progress: 0.71),
        StudentProgress(name: 'Shaan Mahajan', progress: 0.42, alert: StudentAlert(label: 'Falling behind in Maths', type: StudentAlertType.warning)),
        StudentProgress(name: 'Ruby Watkins', progress: 0.64),
        StudentProgress(name: 'Myra Li', progress: 0.58),
        StudentProgress(name: 'Caspian Singh', progress: 0.36, alert: StudentAlert(label: 'Low Performance', type: StudentAlertType.danger)),
      ],
    );
  }

  static ClassProgressData _class8() {
    return ClassProgressData(
      summary: const ProgressSummary(modules: 15, students: 52),
      mathematics: SubjectDetail(
        name: 'Mathematics',
        status: SubjectStatus.completed,
        focusArea: 'Arithmetic Progressions',
        collapsedModules: const ['Data Handling', 'Mensuration'],
        chapters: const [
          ChapterProgress(
            title: 'Chapter 1: AP Basics (12/12 Topics)',
            progress: 1.0,
            progressLabel: '100%',
          ),
          ChapterProgress(
            title: 'Chapter 2: Factors & Multiples (8/8 Topics)',
            progress: 1.0,
            progressLabel: '100%',
          ),
          ChapterProgress(
            title: 'Chapter 3: Geometry Review (8/10 Topics)',
            progress: 0.80,
            progressLabel: '80%',
          ),
        ],
      ),
      additionalSubjects: const [
        SubjectSummary(name: 'Physics', status: SubjectStatus.completed),
        SubjectSummary(name: 'English', status: SubjectStatus.inProgress),
        SubjectSummary(name: 'History', status: SubjectStatus.inProgress),
      ],
      students: const [
        StudentProgress(name: 'Nikhil Shah', progress: 0.9),
        StudentProgress(name: 'Sara Ghosh', progress: 0.82),
        StudentProgress(name: 'Aleena Thomas', progress: 0.74),
        StudentProgress(name: 'Raul Iyer', progress: 0.68),
      ],
    );
  }
}
