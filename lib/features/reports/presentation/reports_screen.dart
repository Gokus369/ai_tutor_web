import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/reports/data/reports_demo_data.dart';
import 'package:ai_tutor_web/features/reports/domain/models/reports_models.dart';
import 'package:ai_tutor_web/features/reports/presentation/widgets/reports_header.dart';
import 'package:ai_tutor_web/features/reports/presentation/widgets/reports_view.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  ReportsScreen({super.key, ReportsData? data}) : data = data ?? ReportsDemoData.build();

  final ReportsData data;

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ReportsData _data = widget.data;
  late String _selectedClass = widget.data.initialClass;

  @override
  void didUpdateWidget(covariant ReportsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _data = widget.data;
      _selectedClass = _data.initialClass;
    }
  }

  void _onClassChanged(String value) {
    setState(() => _selectedClass = value);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.reports,
      title: 'Reports',
      alignContentToStart: true,
      maxContentWidth: 1200,
      headerBuilder: (context, shell) {
        return ReportsHeader(
          data: _data,
          selectedClass: _selectedClass,
          onClassChanged: _onClassChanged,
          onExportPressed: () {},
          narrow: shell.contentWidth < 720,
        );
      },
      builder: (context, shell) {
        return ReportsView(
          data: _data,
          selectedClass: _selectedClass,
          onClassChanged: _onClassChanged,
          onExportPressed: () {},
          showHeader: false,
        );
      },
    );
  }
}
