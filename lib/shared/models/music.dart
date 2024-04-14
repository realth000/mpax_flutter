part of 'models.dart';

/// Model of song used in all.
@MappableClass()
final class MusicModel with MusicModelMappable {
  const MusicModel({
    required this.filePath,
    required this.filename,
    required this.title,
  });

  ////////// File raw info //////////
  final String filePath;
  final String filename;

  ////////// Metadata //////////
  final String? title;
}
