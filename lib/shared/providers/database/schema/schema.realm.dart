// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Album extends _Album with RealmEntity, RealmObjectBase, RealmObject {
  Album(
    ObjectId id,
    String name, {
    Iterable<ObjectId> artists = const [],
    Iterable<ObjectId> songs = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'artists', RealmList<ObjectId>(artists));
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'songs', RealmList<ObjectId>(songs));
  }

  Album._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<ObjectId> get artists =>
      RealmObjectBase.get<ObjectId>(this, 'artists') as RealmList<ObjectId>;
  @override
  set artists(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<ObjectId> get songs =>
      RealmObjectBase.get<ObjectId>(this, 'songs') as RealmList<ObjectId>;
  @override
  set songs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Album>> get changes =>
      RealmObjectBase.getChanges<Album>(this);

  @override
  Album freeze() => RealmObjectBase.freezeObject<Album>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'artists': artists.toEJson(),
      'songs': songs.toEJson(),
    };
  }

  static EJsonValue _toEJson(Album value) => value.toEJson();
  static Album _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'artists': EJsonValue artists,
        'songs': EJsonValue songs,
      } =>
        Album(
          fromEJson(id),
          fromEJson(name),
          artists: fromEJson(artists),
          songs: fromEJson(songs),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Album._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Album, 'Album', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('artists', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
      SchemaProperty('songs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Artist extends _Artist with RealmEntity, RealmObjectBase, RealmObject {
  Artist(
    ObjectId id,
    String name, {
    Iterable<ObjectId> songs = const [],
    Iterable<ObjectId> albums = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'songs', RealmList<ObjectId>(songs));
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'albums', RealmList<ObjectId>(albums));
  }

  Artist._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  RealmList<ObjectId> get songs =>
      RealmObjectBase.get<ObjectId>(this, 'songs') as RealmList<ObjectId>;
  @override
  set songs(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<ObjectId> get albums =>
      RealmObjectBase.get<ObjectId>(this, 'albums') as RealmList<ObjectId>;
  @override
  set albums(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Artist>> get changes =>
      RealmObjectBase.getChanges<Artist>(this);

  @override
  Artist freeze() => RealmObjectBase.freezeObject<Artist>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'name': name.toEJson(),
      'songs': songs.toEJson(),
      'albums': albums.toEJson(),
    };
  }

  static EJsonValue _toEJson(Artist value) => value.toEJson();
  static Artist _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'name': EJsonValue name,
        'songs': EJsonValue songs,
        'albums': EJsonValue albums,
      } =>
        Artist(
          fromEJson(id),
          fromEJson(name),
          songs: fromEJson(songs),
          albums: fromEJson(albums),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Artist._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Artist, 'Artist', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('songs', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
      SchemaProperty('albums', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Song extends _Song with RealmEntity, RealmObjectBase, RealmObject {
  Song(
    ObjectId id,
    String filePath,
    String filename,
    String title,
    ObjectId album, {
    Iterable<ObjectId> artists = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'filePath', filePath);
    RealmObjectBase.set(this, 'filename', filename);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set<RealmList<ObjectId>>(
        this, 'artists', RealmList<ObjectId>(artists));
    RealmObjectBase.set(this, 'album', album);
  }

  Song._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get filePath =>
      RealmObjectBase.get<String>(this, 'filePath') as String;
  @override
  set filePath(String value) => RealmObjectBase.set(this, 'filePath', value);

  @override
  String get filename =>
      RealmObjectBase.get<String>(this, 'filename') as String;
  @override
  set filename(String value) => RealmObjectBase.set(this, 'filename', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  RealmList<ObjectId> get artists =>
      RealmObjectBase.get<ObjectId>(this, 'artists') as RealmList<ObjectId>;
  @override
  set artists(covariant RealmList<ObjectId> value) =>
      throw RealmUnsupportedSetError();

  @override
  ObjectId get album =>
      RealmObjectBase.get<ObjectId>(this, 'album') as ObjectId;
  @override
  set album(ObjectId value) => RealmObjectBase.set(this, 'album', value);

  @override
  Stream<RealmObjectChanges<Song>> get changes =>
      RealmObjectBase.getChanges<Song>(this);

  @override
  Song freeze() => RealmObjectBase.freezeObject<Song>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'filePath': filePath.toEJson(),
      'filename': filename.toEJson(),
      'title': title.toEJson(),
      'artists': artists.toEJson(),
      'album': album.toEJson(),
    };
  }

  static EJsonValue _toEJson(Song value) => value.toEJson();
  static Song _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        'id': EJsonValue id,
        'filePath': EJsonValue filePath,
        'filename': EJsonValue filename,
        'title': EJsonValue title,
        'artists': EJsonValue artists,
        'album': EJsonValue album,
      } =>
        Song(
          fromEJson(id),
          fromEJson(filePath),
          fromEJson(filename),
          fromEJson(title),
          fromEJson(album),
          artists: fromEJson(artists),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Song._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Song, 'Song', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('filePath', RealmPropertyType.string),
      SchemaProperty('filename', RealmPropertyType.string),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('artists', RealmPropertyType.objectid,
          collectionType: RealmCollectionType.list),
      SchemaProperty('album', RealmPropertyType.objectid),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
