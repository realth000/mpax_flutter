part of 'models.dart';

/// Metadata info with extra file info.
@MappableClass()
final class FileMetadataModel with FileMetadataModelMappable {
  /// Constructor.
  const FileMetadataModel(
    this.filePath,
    this.metadataModel,
  );

  /// File path of the model.
  final String filePath;

  /// Metadata info.
  final MetadataModel metadataModel;
}
