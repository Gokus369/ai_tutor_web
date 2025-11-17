import 'package:ai_tutor_web/app/router/app_routes.dart';
import 'package:ai_tutor_web/features/media/domain/models/media_item.dart';
import 'package:ai_tutor_web/features/media/presentation/widgets/media_management_header.dart';
import 'package:ai_tutor_web/features/media/presentation/widgets/media_list.dart';
import 'package:ai_tutor_web/features/media/presentation/widgets/media_upload_section.dart';
import 'package:ai_tutor_web/shared/layout/dashboard_page.dart';
import 'package:flutter/material.dart';

class MediaManagementScreen extends StatefulWidget {
  const MediaManagementScreen({super.key});

  @override
  State<MediaManagementScreen> createState() => _MediaManagementScreenState();
}

const List<String> _classOptions = [
  'Class 10',
  'Class 11',
  'Class 12',
  'All Classes',
];

final List<MediaItem> _seedMedia = List.unmodifiable([
  MediaItem(
    title: 'Introduction to Photosynthesis',
    type: MediaType.video,
    fileType: 'Video',
    sizeLabel: '120 MB',
    uploadedOn: DateTime(2025, 9, 15),
  ),
  MediaItem(
    title: 'Chemical Bonding Notes',
    type: MediaType.document,
    fileType: 'PDF',
    sizeLabel: '4.5 MB',
    uploadedOn: DateTime(2025, 9, 14),
  ),
  MediaItem(
    title: 'Algebraic Equations Worksheet',
    type: MediaType.document,
    fileType: 'PDF',
    sizeLabel: '2.1 MB',
    uploadedOn: DateTime(2025, 9, 13),
  ),
  MediaItem(
    title: 'Historical Timeline Images',
    type: MediaType.image,
    fileType: 'Image',
    sizeLabel: '36 MB',
    uploadedOn: DateTime(2025, 9, 10),
  ),
  MediaItem(
    title: 'French Pronunciation Guide',
    type: MediaType.document,
    fileType: 'PDF',
    sizeLabel: '6.2 MB',
    uploadedOn: DateTime(2025, 9, 9),
  ),
]);

class _MediaManagementScreenState extends State<MediaManagementScreen> {
  String _selectedClass = _classOptions.first;
  final List<MediaItem> _media = List.of(_seedMedia);

  @override
  Widget build(BuildContext context) {
    return DashboardPage(
      activeRoute: AppRoutes.mediaManagement,
      title: 'Media Management',
      headerBuilder: (context, shell) {
        final double width = shell.contentWidth;
        final bool stackHeader = width < 720;
        return MediaManagementHeader(
          title: 'Media Management',
          classOptions: _classOptions,
          selectedClass: _selectedClass,
          stacked: stackHeader,
          onClassChanged: (value) => setState(() => _selectedClass = value),
          onUploadNew: () {
            _showSnackBar(context, 'Upload new media tapped');
          },
        );
      },
      builder: (context, shell) {
        final double width = shell.contentWidth;
        final bool isNarrow = width < 880;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MediaUploadSection(
              onUploadTap: () => _showSnackBar(context, 'Upload area tapped'),
              isCompact: isNarrow,
            ),
            const SizedBox(height: 28),
            MediaListSection(
              media: _media,
              isCompact: isNarrow,
              onMenuTap: (item) =>
                  _showSnackBar(context, 'Menu tapped for "${item.title}"'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
