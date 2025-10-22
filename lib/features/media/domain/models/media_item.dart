class MediaItem {
  const MediaItem({
    required this.title,
    required this.type,
    required this.fileType,
    required this.uploadedOn,
    required this.sizeLabel,
  });

  final String title;
  final MediaType type;
  final String fileType;
  final DateTime uploadedOn;
  final String sizeLabel;
}

enum MediaType {
  video,
  document,
  image,
}

extension MediaTypeX on MediaType {
  String get label {
    switch (this) {
      case MediaType.video:
        return 'Video';
      case MediaType.document:
        return 'Document';
      case MediaType.image:
        return 'Image';
    }
  }

  String get iconLabel {
    switch (this) {
      case MediaType.video:
        return 'Video';
      case MediaType.document:
        return 'PDF';
      case MediaType.image:
        return 'Image';
    }
  }
}
