import 'package:flutter/material.dart';

class CohortMetric {
  const CohortMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBackground,
    required this.description,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconBackground;
  final String description;
}
