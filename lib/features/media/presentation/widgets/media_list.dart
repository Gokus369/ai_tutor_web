import 'package:ai_tutor_web/features/media/domain/models/media_item.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class MediaListSection extends StatelessWidget {
  const MediaListSection({
    super.key,
    required this.media,
    required this.onMenuTap,
    this.isCompact = false,
  });

  final List<MediaItem> media;
  final ValueChanged<MediaItem> onMenuTap;
  final bool isCompact;

  static const double _itemHeight = 94;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.studentsCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Uploaded Media (${media.length})',
                  style: AppTypography.sectionTitle,
                ),
              ),
              if (!isCompact)
                Text(
                  'Manage your latest lessons and resources',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              for (int i = 0; i < media.length; i++) ...[
                _MediaListTile(
                  item: media[i],
                  onMenuTap: onMenuTap,
                ),
                if (i != media.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MediaListTile extends StatelessWidget {
  const _MediaListTile({
    required this.item,
    required this.onMenuTap,
  });

  final MediaItem item;
  final ValueChanged<MediaItem> onMenuTap;

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = item.uploadedOn;
    final String day = dateTime.day.toString().padLeft(2, '0');
    final String month = dateTime.month.toString().padLeft(2, '0');
    final String date = '$day/$month/${dateTime.year}';

    return Container(
      height: MediaListSection._itemHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.studentsCardBorder),
        color: AppColors.studentsCardBackground,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          _MediaTypeBadge(type: item.type),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: AppTypography.sectionTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.fileType} | ${item.sizeLabel} | $date',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onMenuTap(item),
            icon: const Icon(Icons.more_horiz, color: AppColors.iconMuted),
          ),
        ],
      ),
    );
  }
}

class _MediaTypeBadge extends StatelessWidget {
  const _MediaTypeBadge({required this.type});

  final MediaType type;

  @override
  Widget build(BuildContext context) {
    final Color background;
    final IconData icon;

    switch (type) {
      case MediaType.video:
        background = AppColors.quickActionBlue;
        icon = Icons.play_circle_outline;
        break;
      case MediaType.document:
        background = AppColors.quickActionPurple;
        icon = Icons.description_outlined;
        break;
      case MediaType.image:
        background = AppColors.quickActionGreen;
        icon = Icons.image_outlined;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: background, size: 24),
    );
  }
}
