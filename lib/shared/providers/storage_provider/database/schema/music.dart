part of 'schema.dart';

/// Music table
@DataClassName('MusicEntity')
class Music extends Table {
  /// Id.
  IntColumn get id => integer().autoIncrement()();

  ////////// File raw info //////////
  /// File path.
  ///
  /// Unique key.
  TextColumn get filePath => text().unique()();

  /// Related directory source path.
  ///
  /// Use this column to record each music's source.
  TextColumn get sourceDir => text()();

  /// File name.
  TextColumn get fileName => text()();

  ////////// Metadata //////////

  /// Title.
  TextColumn get title => text().nullable()();

  /// Artists.
  ///
  /// Store all artists' name.
  ///
  /// The source list of string SHOULD be sorted before serialized into
  /// [StringSet].
  ///
  /// We do not store artist id here as we use artist name as the only key
  /// to identify an artist.
  TextColumn get artist => text().map(StringSet.converter).nullable()();

  /// Album.
  ///
  /// Store album's id ant title here.
  TextColumn get album => text().map(IntStringPair.converter).nullable()();

  /// Track number in the album.
  IntColumn get track => integer().nullable()();

  /// Publish year.
  IntColumn get year => integer().nullable()();

  /// Genre name.
  TextColumn get genre => text().nullable()();

  /// Comment.
  TextColumn get comment => text().nullable()();

  /// Sample rate.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  IntColumn get sampleRate => integer().nullable()();

  /// Bitrate.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  IntColumn get bitrate => integer().nullable()();

  /// Channels number.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  IntColumn get channels => integer().nullable()();

  /// Duration in milliseconds.
  ///
  /// This field should not be null because it's audio property, but keep it
  /// nullable for some special situation.
  IntColumn get duration => integer().nullable()();

  /// Album artists.
  ///
  /// Store all artists' id and name.
  TextColumn get albumArtist => text().map(StringSet.converter).nullable()();

  /// All track count in album.
  IntColumn get albumTotalTracks => integer().nullable()();
}
