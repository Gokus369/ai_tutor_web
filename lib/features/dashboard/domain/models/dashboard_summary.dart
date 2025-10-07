import 'package:flutter/material.dart';

/// Simple data model representing a metric shown in the dashboard header.
class DashboardSummary {
  const DashboardSummary({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconBackground,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color iconBackground;
}
