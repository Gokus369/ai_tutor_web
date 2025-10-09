import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_shell.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return DashboardShell(
      activeRoute: AppRoutes.settings,
      builder: (context, shell) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: AppTypography.dashboardTitle),
            const SizedBox(height: 24),
            _SettingsCard(
              notificationsEnabled: _notificationsEnabled,
              onToggleNotifications: (value) =>
                  setState(() => _notificationsEnabled = value),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.notificationsEnabled,
    required this.onToggleNotifications,
  });

  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;

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
          _ProfileHeader(),
          const SizedBox(height: 32),
          _SettingsSection(
            title: 'Account Settings',
            children: [
              _SettingsTile(
                icon: Icons.lock_outline,
                label: 'Change Password',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.notifications_active_outlined,
                label: 'Manage Notifications',
                trailing: Switch.adaptive(
                  value: notificationsEnabled,
                  onChanged: onToggleNotifications,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SettingsSection(
            title: 'Preferences',
            children: [
              _SettingsTile(
                icon: Icons.menu_book_outlined,
                label: 'Academic Preferences',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SettingsSection(
            title: 'Info',
            children: [
              _SettingsTile(
                icon: Icons.info_outline,
                label: 'About Us',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.description_outlined,
                label: 'Term & Conditions',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 28),
          _SettingsTile(
            icon: Icons.logout_rounded,
            label: 'Logout',
            onTap: () {},
            accent: true,
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isCompact = constraints.maxWidth < 720;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCompact) ...[
              _ProfileDetails(),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 163,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      textStyle: AppTypography.button.copyWith(fontSize: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ),
              ),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _ProfileDetails(),
                  const Spacer(),
                  SizedBox(
                    width: 163,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        textStyle: AppTypography.button.copyWith(fontSize: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text('Edit Profile'),
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

class _ProfileDetails extends StatelessWidget {
  const _ProfileDetails();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.sidebarBorder, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 50,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.network(
              'https://i.pravatar.cc/150?img=47',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.summaryTileBackground,
                alignment: Alignment.center,
                child: Text(
                  'MR',
                  style: AppTypography.sectionTitle.copyWith(
                    fontSize: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Moni Roy',
              style: AppTypography.sectionTitle.copyWith(fontSize: 24),
            ),
            const SizedBox(height: 6),
            Text(
              'moni.roy123@gmail.com',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 14,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Teacher',
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentGreen,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.sectionTitle.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 18),
        Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(height: 16),
              children[i],
            ],
          ],
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
    this.accent = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final Color baseBackground = Colors.white;
    final Color borderColor = accent
        ? AppColors.accentPink.withValues(alpha: 0.4)
        : AppColors.sidebarBorder.withValues(alpha: 0.8);
    final Color iconBackground = accent
        ? AppColors.accentPink.withValues(alpha: 0.14)
        : AppColors.searchFieldBackground;
    final Color iconColor = accent ? AppColors.accentPink : AppColors.primary;
    final TextStyle textStyle = AppTypography.bodySmall.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: accent ? AppColors.accentPink : AppColors.textPrimary,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 92,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: baseBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Text(
                  label,
                  style: textStyle,
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.iconMuted,
                    size: 28,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
