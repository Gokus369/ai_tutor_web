import 'package:ai_tutor_web/app/theme/app_theme.dart';
import 'package:ai_tutor_web/features/media/domain/models/media_item.dart';
import 'package:ai_tutor_web/features/media/presentation/widgets/media_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final media = [
    MediaItem(
      title: 'Photosynthesis',
      type: MediaType.video,
      fileType: 'Video',
      sizeLabel: '120 MB',
      uploadedOn: DateTime(2024, 6, 2),
    ),
  ];

  Widget wrapWithApp(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders media list tile with formatted metadata', (
    tester,
  ) async {
    MediaItem? tapped;

    await tester.pumpWidget(
      wrapWithApp(
        MediaListSection(media: media, onMenuTap: (item) => tapped = item),
      ),
    );

    expect(find.text('Uploaded Media (1)'), findsOneWidget);
    expect(find.text('Photosynthesis'), findsOneWidget);
    expect(find.textContaining('02/06/2024'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_horiz));
    expect(tapped, media.first);
  });

  testWidgets('hides description helper when compact', (tester) async {
    await tester.pumpWidget(
      wrapWithApp(
        MediaListSection(media: media, onMenuTap: (_) {}, isCompact: true),
      ),
    );

    expect(find.text('Manage your latest lessons and resources'), findsNothing);
  });
}
