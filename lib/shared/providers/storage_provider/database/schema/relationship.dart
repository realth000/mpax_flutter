part of 'schema.dart';

/// Relationship between [Music] and [Album].
///
/// Many to one.
///
/// Each record in this table represent one combination of items in tables.
@DataClassName('MusicAlbumEntry')
class MusicAlbumEntries extends Table {
  /// Music id.
  IntColumn get music => integer().references(Music, #id)();

  /// Album id.
  IntColumn get album => integer().references(Album, #id)();

  @override
  Set<Column> get primaryKey => {music, album};
}

/// Relationship between [Music] and [Artist].
///
/// Many to many.
///
/// Each record in this table represent one combination of items in tables.
@DataClassName('MusicArtistEntry')
class MusicArtistEntries extends Table {
  /// Music id.
  IntColumn get music => integer().references(Music, #id)();

  /// Artist id.
  IntColumn get artist => integer().references(Artist, #id)();

  @override
  Set<Column> get primaryKey => {music, artist};
}

/// Relationship between [Artist] and [Album].
///
/// Many to many.
///
/// Each record in this table represent one combination of items in tables.
@DataClassName('ArtistAlbumEntry')
class ArtistAlbumEntries extends Table {
  /// Artist id.
  IntColumn get artist => integer().references(Artist, #id)();

  /// Album id.
  IntColumn get album => integer().references(Album, #id)();

  @override
  Set<Column> get primaryKey => {artist, album};
}

/// Relationship between [Playlist] and [Music].
///
/// Many to many.
///
/// Each record in this table represent one combination of items in tables.
@DataClassName('PlaylistMusicEntry')
class PlaylistMusicEntries extends Table {
  /// Playlist id.
  IntColumn get playlist => integer().references(Playlist, #id)();

  /// Music id.
  IntColumn get music => integer().references(Music, #id)();

  @override
  Set<Column> get primaryKey => {playlist, music};
}

///////////////////// Image Cache /////////////////////
/// These tables are to record many-to-one image usages and images.
///
/// For example, many music can have the same image cover (maybe in the same)
/// album, playlist can have a same image with music.
///
/// And images are cached in some dir for quick loading. So these tables are
/// recording those relationships between images and images usages.

/// Record [Image]s used in [Music] table.
@DataClassName('MusicImageEntry')
class MusicImageEntries extends Table {
  /// Music id.
  IntColumn get music => integer().references(Music, #id)();

  /// Image id.
  IntColumn get image => integer().references(Image, #id)();

  @override
  Set<Column> get primaryKey => {music, image};
}

/// Record [Image]s used in [Album] table.
@DataClassName('AlbumImageEntry')
class AlbumImageEntries extends Table {
  /// Album id.
  IntColumn get album => integer().references(Album, #id)();

  /// Image id.
  IntColumn get image => integer().references(Image, #id)();

  @override
  Set<Column> get primaryKey => {album, image};
}

/// Record [Image]s used in [Playlist]s.
class PlaylistImageEntries extends Table {
  /// Playlist id.
  IntColumn get playlist => integer().references(Playlist, #id)();

  /// Image id.
  IntColumn get image => integer().references(Image, #id)();

  @override
  Set<Column> get primaryKey => {playlist, image};
}
