import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/attendance/domain/models/attendance_record.dart';
import 'package:ai_tutor_web/features/attendance/presentation/widgets/attendance_filters_bar.dart';
import 'package:ai_tutor_web/features/attendance/presentation/widgets/attendance_summary_card.dart';
import 'package:ai_tutor_web/features/attendance/presentation/widgets/attendance_table.dart';
import 'package:ai_tutor_web/features/lessons/presentation/utils/lesson_formatters.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

const List<String> _classOptions = [
  'All Classes',
  'Class 10',
  'Class 11',
  'Class 12',
];

const List<String> _subjectOptions = [
  'All Subjects',
  'Mathematics',
  'Science',
  'English',
  'History',
];

final List<AttendanceRecord> _seedRecords = [
  const AttendanceRecord(
    name: 'Makai Brooks',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'Linear Equations Introduction',
    status: AttendanceStatus.present,
  ),
  const AttendanceRecord(
    name: 'Ana Bartlett',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'Solving Word Problems',
    status: AttendanceStatus.present,
  ),
  const AttendanceRecord(
    name: 'Aaron Whitley',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'States of Matter',
    status: AttendanceStatus.absent,
  ),
  const AttendanceRecord(
    name: 'Kenya Dillard',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'Poetry Analysis Workshop',
    status: AttendanceStatus.late,
  ),
  const AttendanceRecord(
    name: 'Mohammed Wong',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'Geometry Review',
    status: AttendanceStatus.present,
  ),
  const AttendanceRecord(
    name: 'Camryn Gregory',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'Geometry Review',
    status: AttendanceStatus.present,
  ),
  const AttendanceRecord(
    name: 'Aubrey Cabrera',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'Geometry Review',
    status: AttendanceStatus.present,
  ),
  const AttendanceRecord(
    name: 'Kevin Walls',
    className: 'Class 10',
    subject: 'Mathematics',
    notes: 'Algebraic Identities',
    status: AttendanceStatus.absent,
  ),
];

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final TextEditingController _dateController = TextEditingController(
    text: formatLessonDate(_selectedDate),
  );

  final List<AttendanceRecord> _records = List.of(_seedRecords);
  String _selectedClass = _classOptions[1];
  String _selectedSubject = _subjectOptions[1];
  DateTime _selectedDate = DateTime(2025, 9, 2);

  @override
  void dispose() {
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  List<AttendanceRecord> get _filteredRecords {
    final String query = _searchController.text.trim().toLowerCase();
    final bool filterAllClasses = _selectedClass == _classOptions.first;
    final bool filterAllSubjects = _selectedSubject == _subjectOptions.first;

    final filtered = _records.where((record) {
      final matchesClass =
          filterAllClasses || record.className == _selectedClass;
      final matchesSubject =
          filterAllSubjects || record.subject == _selectedSubject;
      final matchesQuery =
          query.isEmpty ||
          record.name.toLowerCase().contains(query) ||
          record.notes.toLowerCase().contains(query);
      return matchesClass && matchesSubject && matchesQuery;
    }).toList()..sort(AttendanceRecord.compareByName);

    return filtered;
  }

  void _handleStatusChange(AttendanceRecord record, AttendanceStatus status) {
    if (record.status == status) return;
    setState(() {
      final int index = _records.indexOf(record);
      if (index == -1) return;
      _records[index] = _records[index].copyWith(
        status: status,
        updatedAt: () => DateTime.now(),
      );
    });
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatLessonDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;
    final int total = records.length;
    final int present = records
        .where((r) => r.status == AttendanceStatus.present)
        .length;
    final int absent = records
        .where((r) => r.status == AttendanceStatus.absent)
        .length;
    final int late = records
        .where((r) => r.status == AttendanceStatus.late)
        .length;

    return DashboardShell(
      activeRoute: AppRoutes.attendance,
      builder: (context, shell) {
        final bool stackSummary = shell.contentWidth < 1040;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Attendance', style: AppTypography.dashboardTitle),
            const SizedBox(height: 20),
            AttendanceFiltersBar(
              searchController: _searchController,
              dateController: _dateController,
              classOptions: _classOptions,
              subjectOptions: _subjectOptions,
              selectedClass: _selectedClass,
              selectedSubject: _selectedSubject,
              onClassChanged: (value) => setState(() => _selectedClass = value),
              onSubjectChanged: (value) =>
                  setState(() => _selectedSubject = value),
              onPickDate: _pickDate,
              onSearchChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            if (stackSummary)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AttendanceTable(
                    records: records,
                    onStatusUpdated: _handleStatusChange,
                  ),
                  const SizedBox(height: 24),
                  AttendanceSummaryCard(
                    date: _selectedDate,
                    totalStudents: total,
                    presentCount: present,
                    absentCount: absent,
                    lateCount: late,
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AttendanceTable(
                      records: records,
                      onStatusUpdated: _handleStatusChange,
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 320,
                    child: AttendanceSummaryCard(
                      date: _selectedDate,
                      totalStudents: total,
                      presentCount: present,
                      absentCount: absent,
                      lateCount: late,
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
