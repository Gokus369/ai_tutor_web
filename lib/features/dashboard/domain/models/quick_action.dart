import 'package:flutter/material.dart';

/// Data model describing a shortcut action button on the dashboard.
enum QuickActionType {
  createClass,
  addLesson,
  assignQuiz,
  sendAnnouncement,
}

/// Data model describing a shortcut action button on the dashboard.
class QuickAction {
  const QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
    this.type,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final QuickActionType? type;
}
