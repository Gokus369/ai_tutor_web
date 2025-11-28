import 'package:ai_tutor_web/features/settings/domain/models/settings_models.dart';
import 'package:ai_tutor_web/features/settings/presentation/widgets/settings_section.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.profile,
    required this.sections,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
    required this.onEditProfile,
    required this.onNavigate,
  });

  final SettingsProfile profile;
  final List<SettingsSection> sections;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;
  final VoidCallback onEditProfile;
  final ValueChanged<SettingsItem> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF3F6), Color(0xFFF7FBFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.sidebarBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(profile: profile, onEditProfile: onEditProfile),
          const SizedBox(height: 32),
          for (final section in sections) ...[
            SettingsSectionWidget(
              section: section,
              notificationsEnabled: notificationsEnabled,
              onToggleNotifications: onToggleNotifications,
              onNavigate: onNavigate,
            ),
            const SizedBox(height: 28),
          ],
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile, required this.onEditProfile});

  final SettingsProfile profile;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 720;
        final profileDetails = _ProfileDetails(profile: profile);
        final editButton = SizedBox(
          width: 163,
          height: 50,
          child: FilledButton(
            onPressed: onEditProfile,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              textStyle: AppTypography.button.copyWith(fontSize: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: const Text('Edit Profile'),
          ),
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileDetails,
              const SizedBox(height: 24),
              editButton,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: profileDetails),
            editButton,
          ],
        );
      },
    );
  }
}

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails({required this.profile});

  final SettingsProfile profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: profile.avatarColor.withValues(alpha: 0.12),
          child: Text(
            profile.name.substring(0, 1),
            style: AppTypography.dashboardTitle.copyWith(
              fontSize: 28,
              color: profile.avatarColor,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: AppTypography.sectionTitle.copyWith(fontSize: 22),
            ),
            const SizedBox(height: 6),
            Text(
              profile.role,
              style: AppTypography.bodySmall.copyWith(fontSize: 14, color: AppColors.textMuted),
            ),
            const SizedBox(height: 4),
            Text(
              profile.email,
              style: AppTypography.bodySmall.copyWith(fontSize: 13, color: AppColors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
