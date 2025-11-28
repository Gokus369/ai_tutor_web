import 'package:ai_tutor_web/features/settings/domain/models/settings_models.dart';
import 'package:ai_tutor_web/features/settings/presentation/widgets/settings_card.dart';
import 'package:flutter/material.dart';

@visibleForTesting
class SettingsView extends StatelessWidget {
  const SettingsView({
    super.key,
    required this.data,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onEditProfile,
    required this.onNavigate,
  });

  final SettingsData data;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;
  final VoidCallback onEditProfile;
  final ValueChanged<SettingsItem> onNavigate;

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      profile: data.profile,
      sections: data.sections,
      notificationsEnabled: notificationsEnabled,
      onToggleNotifications: onToggleNotifications,
      onEditProfile: onEditProfile,
      onNavigate: onNavigate,
    );
  }
}
