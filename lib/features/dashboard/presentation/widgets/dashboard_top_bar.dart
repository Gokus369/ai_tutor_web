import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.sidebarBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 388,
            height: 38,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: AppColors.iconMuted),
                filled: true,
                fillColor: AppColors.searchFieldBackground,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(
                    color: AppColors.searchFieldBorder,
                    width: 0.6,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(
                    color: AppColors.searchFieldBorder,
                    width: 0.6,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(19),
                  borderSide: const BorderSide(
                    color: AppColors.searchFieldBorder,
                    width: 0.6,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          _NotificationBell(),
          const SizedBox(width: 24),
          _ProfileMenu(),
        ],
      ),
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: AppColors.summaryTileBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.summaryCardBorder),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.quickActionOrange,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Text(
                '6',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      offset: const Offset(0, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (value) {
        // TODO: Hook up account actions when backend is ready.
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: ListTile(
            leading: Icon(Icons.logout_rounded, size: 20, color: AppColors.quickActionOrange.withValues(alpha: 0.9)),
            title: Text(
              'Logout',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.quickActionOrange.withValues(alpha: 0.9),
              ),
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
            title: Text(
              'Delete Account',
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      ],
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.summaryCardBorder),
              color: AppColors.summaryTileBackground,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                'https://i.pravatar.cc/150?img=47',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    'MR',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Moni Roy', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)),
              Text('Admin', style: AppTypography.bodySmall.copyWith(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
          const SizedBox(width: 12),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
        ],
      ),
    );
  }
}
