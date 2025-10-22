import 'package:ai_tutor_web/shared/styles/app_colors.dart';
import 'package:ai_tutor_web/shared/styles/app_typography.dart';
import 'package:flutter/material.dart';

class MediaUploadSection extends StatelessWidget {
  const MediaUploadSection({
    super.key,
    required this.onUploadTap,
    required this.isCompact,
  });

  final VoidCallback onUploadTap;
  final bool isCompact;

  static const double _desktopHeight = 282;
  static const double _desktopDropHeight = 191;
  static const double _compactHeight = 220;
  static const double _compactDropHeight = 150;

  @override
  Widget build(BuildContext context) {
    final double containerHeight = isCompact ? _compactHeight : _desktopHeight;
    final double dropHeight = isCompact ? _compactDropHeight : _desktopDropHeight;

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
      height: containerHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Media', style: AppTypography.sectionTitle),
          const SizedBox(height: 20),
          Expanded(
            child: GestureDetector(
              onTap: onUploadTap,
              child: Container(
                height: dropHeight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.searchFieldBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.32),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: isCompact ? 36 : 44,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Drag files here or click to upload',
                        style: AppTypography.sectionTitle.copyWith(
                          fontSize: isCompact ? 18 : 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Supports videos, PDFs, images, audio files, and documents',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
