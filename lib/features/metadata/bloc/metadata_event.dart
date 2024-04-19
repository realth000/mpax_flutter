part of 'metadata_bloc.dart';

/// Base class of all events used in metadata feature.
@MappableClass()
sealed class MetadataEvent with MetadataEventMappable {
  const MetadataEvent();
}

/// Requested to read metadata from file at [filePath].
@MappableClass()
final class MetadataReadFileRequested extends MetadataEvent
    with MetadataReadFileRequestedMappable {
  /// Constructor.
  const MetadataReadFileRequested(this.filePath);

  /// File path to read metadata from.
  final String filePath;
}

/// Requested to read metadata from all files at [dirPath].
@MappableClass()
final class MetadataReadDirRequested extends MetadataEvent
    with MetadataReadDirRequestedMappable {
  /// Constructor.
  const MetadataReadDirRequested(this.dirPath);

  /// File path to read metadata from.
  final String dirPath;
}
