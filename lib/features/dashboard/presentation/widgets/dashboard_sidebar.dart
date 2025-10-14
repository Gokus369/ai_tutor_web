import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key, required this.activeRoute});

  final String activeRoute;

  static final List<_SidebarItemData> _items = [
    _SidebarItemData(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: AppRoutes.dashboard,
    ),
    _SidebarItemData(
      label: 'Classes',
      icon: Icons.school_outlined,
      route: AppRoutes.classes,
    ),
    _SidebarItemData(
      label: 'Students',
      icon: Icons.group_outlined,
      route: AppRoutes.students,
    ),
    _SidebarItemData(
      label: 'Syllabus',
      icon: Icons.list_alt_outlined,
      route: AppRoutes.syllabus,
    ),
    _SidebarItemData(
      label: 'Lessons Planner',
      icon: Icons.calendar_month_outlined,
      route: AppRoutes.lessons,
    ),
    _SidebarItemData(
      label: 'Attendance',
      icon: Icons.fact_check_outlined,
      route: AppRoutes.attendance,
    ),
    _SidebarItemData(
      label: 'Progress',
      icon: Icons.show_chart_outlined,
      route: AppRoutes.progress,
    ),
    _SidebarItemData(
      label: 'Media Management',
      icon: Icons.perm_media_outlined,
    ),
    _SidebarItemData(
      label: 'Instructor Cohort',
      icon: Icons.people_alt_outlined,
    ),
    _SidebarItemData(
      label: 'Assessments',
      icon: Icons.assignment_turned_in_outlined,
      route: AppRoutes.assessments,
    ),
    _SidebarItemData(label: 'AI Tutor', icon: Icons.smart_toy_outlined),
    _SidebarItemData(
      label: 'Notifications',
      icon: Icons.notifications_outlined,
    ),
    _SidebarItemData(
      label: 'Reports',
      icon: Icons.bar_chart_rounded,
      route: AppRoutes.reports,
    ),
    _SidebarItemData(
      label: 'Settings',
      icon: Icons.settings_outlined,
      route: AppRoutes.settings,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 236,
      decoration: const BoxDecoration(
        color: AppColors.sidebarSurface,
        border: Border(
          right: BorderSide(color: AppColors.sidebarBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('AiTutor', style: AppTypography.brandWordmark),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final data = _items[index];
                return _SidebarItem(
                  data: data,
                  active: data.route != null && data.route == activeRoute,
                  onTap: data.route == null
                      ? null
                      : () {
                          if (data.route == activeRoute) return;
                          Navigator.of(
                            context,
                          ).pushReplacementNamed(data.route!);
                        },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemCount: _items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({required this.data, required this.active, this.onTap});

  final _SidebarItemData data;
  final bool active;
  final VoidCallback? onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool highlighted = widget.active || _hovered;
    final Color background = widget.active
        ? AppColors.primary
        : highlighted
        ? AppColors.primary.withValues(alpha: 0.08)
        : Colors.transparent;

    final TextStyle baseStyle = AppTypography.sidebarItem;
    final TextStyle textStyle = widget.active
        ? AppTypography.sidebarItemActive
        : baseStyle.copyWith(
            color: highlighted ? AppColors.primary : baseStyle.color,
          );

    final Color iconColor = widget.active
        ? Colors.white
        : highlighted
        ? AppColors.primary
        : AppColors.sidebarIcon;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          dense: true,
          minLeadingWidth: 28,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          leading: Icon(widget.data.icon, color: iconColor, size: 22),
          title: Text(widget.data.label, style: textStyle),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}

class _SidebarItemData {
  const _SidebarItemData({required this.label, required this.icon, this.route});

  final String label;
  final IconData icon;
  final String? route;
}
