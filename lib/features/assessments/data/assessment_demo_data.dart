import 'package:ai_tutor_web/features/assessments/domain/models/assessment_models.dart';

class AssessmentDemoData {
  AssessmentDemoData._();

  static AssessmentsPageData build() {
    const filters = AssessmentFilterOptions(
      classOptions: ['Class 10', 'Class 9', 'Class 8'],
      statusOptions: ['All Status', 'Completed', 'Pending', 'Scheduled'],
      subjectOptions: ['All Subjects', 'Maths', 'English', 'Physics', 'Biology', 'Malayalam'],
      initialClass: 'Class 10',
      initialStatus: 'All Status',
      initialSubject: 'All Subjects',
    );

    Map<AssessmentView, AssessmentSectionData> sections = {
      AssessmentView.assignments: AssessmentSectionData(
        view: AssessmentView.assignments,
        columns: const ['Assessment', 'Subject', 'Due Date', 'Status', 'Submitted By'],
        records: const [
          AssessmentRecord(
            title: 'Linear Equations Homework',
            subject: 'Maths',
            dueDateLabel: '05 Sep 2025',
            status: AssessmentStatus.completed,
            submittedBy: '50/50',
          ),
          AssessmentRecord(
            title: 'English Essay - Environment',
            subject: 'English',
            dueDateLabel: '06 Sep 2025',
            status: AssessmentStatus.pending,
            submittedBy: '24/45',
          ),
          AssessmentRecord(
            title: 'Thermodynamics',
            subject: 'Physics',
            dueDateLabel: '08 Sep 2025',
            status: AssessmentStatus.pending,
            submittedBy: '27/50',
          ),
          AssessmentRecord(
            title: 'New Trends in Malayalam',
            subject: 'Malayalam',
            dueDateLabel: '09 Sep 2025',
            status: AssessmentStatus.pending,
            submittedBy: '16/40',
          ),
          AssessmentRecord(
            title: 'Analysis of Macbeth',
            subject: 'English',
            dueDateLabel: '11 Sep 2025',
            status: AssessmentStatus.pending,
            submittedBy: '10/40',
          ),
          AssessmentRecord(
            title: 'Analysis of Fractal Geometry',
            subject: 'Maths',
            dueDateLabel: '12 Sep 2025',
            status: AssessmentStatus.completed,
            submittedBy: '20/30',
          ),
          AssessmentRecord(
            title: 'How Animals Adapt to Urban Environments',
            subject: 'Biology',
            dueDateLabel: '16 Sep 2025',
            status: AssessmentStatus.pending,
            submittedBy: '28/44',
          ),
        ],
      ),
      AssessmentView.quizzes: AssessmentSectionData(
        view: AssessmentView.quizzes,
        columns: const ['Assessment', 'Subject', 'Due Date', 'Status'],
        records: const [
          AssessmentRecord(
            title: 'Science Chapter 5 Quiz',
            subject: 'Maths',
            dueDateLabel: '05 Sep 2025',
            status: AssessmentStatus.completed,
          ),
          AssessmentRecord(
            title: 'History Timeline Quiz',
            subject: 'English',
            dueDateLabel: '06 Sep 2025',
            status: AssessmentStatus.completed,
          ),
          AssessmentRecord(
            title: 'Thermodynamics Quiz',
            subject: 'Physics',
            dueDateLabel: '07 Sep 2025',
            status: AssessmentStatus.completed,
          ),
          AssessmentRecord(
            title: 'New Trends Quiz',
            subject: 'Malayalam',
            dueDateLabel: '08 Sep 2025',
            status: AssessmentStatus.pending,
          ),
          AssessmentRecord(
            title: 'Analysis of Macbeth',
            subject: 'English',
            dueDateLabel: '09 Sep 2025',
            status: AssessmentStatus.pending,
          ),
          AssessmentRecord(
            title: 'Analysis of Fractal Geometry',
            subject: 'Maths',
            dueDateLabel: '12 Sep 2025',
            status: AssessmentStatus.completed,
          ),
          AssessmentRecord(
            title: 'How Animals Adapt to Urban Environments',
            subject: 'Biology',
            dueDateLabel: '13 Sep 2025',
            status: AssessmentStatus.pending,
          ),
        ],
      ),
      AssessmentView.exams: AssessmentSectionData(
        view: AssessmentView.exams,
        columns: const ['Assessment', 'Subject', 'Due Date', 'Status'],
        records: const [
          AssessmentRecord(
            title: 'Mid-term Mathematics',
            subject: 'Maths',
            dueDateLabel: '10 Sep 2025',
            status: AssessmentStatus.scheduled,
          ),
          AssessmentRecord(
            title: 'History Timeline Quiz',
            subject: 'English',
            dueDateLabel: '11 Sep 2025',
            status: AssessmentStatus.scheduled,
          ),
          AssessmentRecord(
            title: 'Thermodynamics Quiz',
            subject: 'Physics',
            dueDateLabel: '12 Sep 2025',
            status: AssessmentStatus.scheduled,
          ),
          AssessmentRecord(
            title: 'New Trends Quiz',
            subject: 'Malayalam',
            dueDateLabel: '12 Sep 2025',
            status: AssessmentStatus.completed,
          ),
          AssessmentRecord(
            title: 'Analysis of Macbeth',
            subject: 'English',
            dueDateLabel: '13 Sep 2025',
            status: AssessmentStatus.completed,
          ),
          AssessmentRecord(
            title: 'Analysis of Fractal Geometry',
            subject: 'Maths',
            dueDateLabel: '14 Sep 2025',
            status: AssessmentStatus.pending,
          ),
          AssessmentRecord(
            title: 'How Animals Adapt to Urban Environments',
            subject: 'Biology',
            dueDateLabel: '15 Sep 2025',
            status: AssessmentStatus.completed,
          ),
        ],
      ),
    };

    return AssessmentsPageData(filters: filters, sections: sections);
  }
}
