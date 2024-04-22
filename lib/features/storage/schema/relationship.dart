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
}
