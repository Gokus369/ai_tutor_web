import 'package:flutter/material.dart';

class SettingsData {
  const SettingsData({
    required this.profile,
    required this.sections,
  });

  final SettingsProfile profile;
  final List<SettingsSection> sections;
}

class SettingsProfile {
  const SettingsProfile({
    required this.name,
    required this.role,
    required this.email,
    required this.avatarColor,
  });

  final String name;
  final String role;
  final String email;
  final Color avatarColor;
}

class SettingsSection {
  const SettingsSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<SettingsItem> items;
}

enum SettingsItemKind { navigation, toggle, action }

class SettingsItem {
  const SettingsItem({
    required this.icon,
    required this.label,
    this.kind = SettingsItemKind.navigation,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final SettingsItemKind kind;
  final bool destructive;
}
