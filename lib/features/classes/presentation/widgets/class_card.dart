import 'package:ai_tutor_web/features/classes/domain/models/class_info.dart';
import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  const ClassCard({
    super.key,
    required this.info,
  });

  final ClassInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 373,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.classCardBorder),
        boxShadow: const [
          BoxShadow(
            color: AppColors.classCardShadow,
            blurRadius: 54,
            offset: Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(info.name, style: AppTypography.classCardTitle),
              Icon(Icons.more_horiz, color: AppColors.grey, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          _BoardBadge(board: info.board),
          const SizedBox(height: 16),
          _IconMetaRow(
            background: AppColors.classStudentIconBackground,
            icon: Icons.people_outline,
            iconColor: AppColors.accentPink,
            text: '${info.studentCount} Students',
          ),
          const SizedBox(height: 16),
          _IconMetaRow(
            background: AppColors.classSubjectIconBackground,
            icon: Icons.menu_book_outlined,
            iconColor: AppColors.classSubjectIconColor,
            text: info.subjectSummary,
            highlightAction: true,
          ),
          const SizedBox(height: 16),
          _SyllabusProgress(progress: info.syllabusProgress),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                textStyle: AppTypography.button.copyWith(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {},
              child: const Text('View Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardBadge extends StatelessWidget {
  const _BoardBadge({required this.board});

  final String board;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 27,
      decoration: BoxDecoration(
        color: AppColors.classBadgeBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(child: Text(board, style: AppTypography.classCardBadge)),
    );
  }
}

class _IconMetaRow extends StatelessWidget {
  const _IconMetaRow({
    required this.background,
    required this.icon,
    required this.text,
    this.highlightAction = false,
    this.iconColor,
  });

  final Color background;
  final IconData icon;
  final String text;
  final bool highlightAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.classSubjectIconColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: highlightAction ? _buildRichText() : Text(text, style: AppTypography.classCardMeta),
        ),
      ],
    );
  }

  Widget _buildRichText() {
    return RichText(
      text: TextSpan(
        style: AppTypography.classCardDescription,
        children: [
          TextSpan(text: '$text '),
          TextSpan(
            text: 'See More',
            style: AppTypography.classCardDescription.copyWith(
              color: AppColors.accentPink,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class _SyllabusProgress extends StatelessWidget {
  const _SyllabusProgress({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Syllabus Progress', style: AppTypography.classProgressLabel),
            const Spacer(),
            SizedBox(
              width: 40,
              child: Text(
                '${(progress * 100).round()}%',
                style: AppTypography.classProgressValue,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.classProgressTrack,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.classProgressValue,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
