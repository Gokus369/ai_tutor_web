import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/auth_repository.dart';
import 'package:ai_tutor_web/features/settings/data/settings_demo_data.dart';
import 'package:ai_tutor_web/features/settings/domain/models/settings_models.dart';
import 'package:ai_tutor_web/features/settings/presentation/widgets/settings_view.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key, required this.repository, SettingsData? data})
      : data = data ?? SettingsDemoData.build();

  final AuthRepository repository;
  final SettingsData data;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;

  void _toggleNotifications(bool value) {
    setState(() => _notificationsEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.settings,
      title: 'Settings',
      alignContentToStart: true,
      maxContentWidth: 1200,
      builder: (_, __) {
        return SettingsView(
          data: widget.data,
          notificationsEnabled: _notificationsEnabled,
          onToggleNotifications: _toggleNotifications,
          onEditProfile: () {},
          onNavigate: _handleNavigate,
        );
      },
    );
  }

  Future<void> _handleNavigate(SettingsItem item) async {
    if (item.kind == SettingsItemKind.action && item.destructive && item.label == 'Logout') {
      try {
        await widget.repository.logout();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: $e')),
          );
        }
      }
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }
}
