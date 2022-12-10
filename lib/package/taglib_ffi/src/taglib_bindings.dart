// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
import 'dart:ffi' as ffi;

class NativeLibrary {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeLibrary(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeLibrary.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  /// !
  /// By default all strings coming into or out of TagLib's C API are in UTF8.
  /// However, it may be desirable for TagLib to operate on Latin1 (ISO-8859-1)
  /// strings in which case this should be set to FALSE.
  void taglib_set_strings_unicode(
    int unicode,
  ) {
    return _taglib_set_strings_unicode(
      unicode,
    );
  }

  late final _taglib_set_strings_unicodePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int)>>(
          'taglib_set_strings_unicode');
  late final _taglib_set_strings_unicode =
      _taglib_set_strings_unicodePtr.asFunction<void Function(int)>();

  /// !
  /// TagLib can keep track of strings that are created when outputting tag values
  /// and clear them using taglib_tag_clear_strings().  This is enabled by default.
  /// However if you wish to do more fine grained management of strings, you can do
  /// so by setting \a management to FALSE.
  void taglib_set_string_management_enabled(
    int management,
  ) {
    return _taglib_set_string_management_enabled(
      management,
    );
  }

  late final _taglib_set_string_management_enabledPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int)>>(
          'taglib_set_string_management_enabled');
  late final _taglib_set_string_management_enabled =
      _taglib_set_string_management_enabledPtr.asFunction<void Function(int)>();

  /// !
  /// Explicitly free a string returned from TagLib
  void taglib_free(
    ffi.Pointer<ffi.Void> pointer,
  ) {
    return _taglib_free(
      pointer,
    );
  }

  late final _taglib_freePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'taglib_free');
  late final _taglib_free =
      _taglib_freePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();

  /// !
  /// Creates a TagLib file based on \a filename.  TagLib will try to guess the file
  /// type.
  ///
  /// \returns NULL if the file type cannot be determined or the file cannot
  /// be opened.
  ffi.Pointer<TagLib_File> taglib_file_new(
    ffi.Pointer<ffi.Char> filename,
  ) {
    return _taglib_file_new(
      filename,
    );
  }

  late final _taglib_file_newPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<TagLib_File> Function(
              ffi.Pointer<ffi.Char>)>>('taglib_file_new');
  late final _taglib_file_new = _taglib_file_newPtr
      .asFunction<ffi.Pointer<TagLib_File> Function(ffi.Pointer<ffi.Char>)>();

  /// !
  /// Creates a TagLib file based on \a filename.  Rather than attempting to guess
  /// the type, it will use the one specified by \a type.
  ffi.Pointer<TagLib_File> taglib_file_new_type(
    ffi.Pointer<ffi.Char> filename,
    int type,
  ) {
    return _taglib_file_new_type(
      filename,
      type,
    );
  }

  late final _taglib_file_new_typePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<TagLib_File> Function(
              ffi.Pointer<ffi.Char>, ffi.Int32)>>('taglib_file_new_type');
  late final _taglib_file_new_type = _taglib_file_new_typePtr.asFunction<
      ffi.Pointer<TagLib_File> Function(ffi.Pointer<ffi.Char>, int)>();

  /// !
  /// Frees and closes the file.
  void taglib_file_free(
    ffi.Pointer<TagLib_File> file,
  ) {
    return _taglib_file_free(
      file,
    );
  }

  late final _taglib_file_freePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<TagLib_File>)>>(
          'taglib_file_free');
  late final _taglib_file_free = _taglib_file_freePtr
      .asFunction<void Function(ffi.Pointer<TagLib_File>)>();

  /// !
  /// Returns true if the file is open and readable and valid information for
  /// the Tag and / or AudioProperties was found.
  int taglib_file_is_valid(
    ffi.Pointer<TagLib_File> file,
  ) {
    return _taglib_file_is_valid(
      file,
    );
  }

  late final _taglib_file_is_validPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Pointer<TagLib_File>)>>(
          'taglib_file_is_valid');
  late final _taglib_file_is_valid = _taglib_file_is_validPtr
      .asFunction<int Function(ffi.Pointer<TagLib_File>)>();

  /// !
  /// Returns a pointer to the tag associated with this file.  This will be freed
  /// automatically when the file is freed.
  ffi.Pointer<TagLib_Tag> taglib_file_tag(
    ffi.Pointer<TagLib_File> file,
  ) {
    return _taglib_file_tag(
      file,
    );
  }

  late final _taglib_file_tagPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<TagLib_Tag> Function(
              ffi.Pointer<TagLib_File>)>>('taglib_file_tag');
  late final _taglib_file_tag = _taglib_file_tagPtr
      .asFunction<ffi.Pointer<TagLib_Tag> Function(ffi.Pointer<TagLib_File>)>();

  /// !
  /// Returns a pointer to the audio properties associated with this file.  This
  /// will be freed automatically when the file is freed.
  ffi.Pointer<TagLib_AudioProperties> taglib_file_audioproperties(
    ffi.Pointer<TagLib_File> file,
  ) {
    return _taglib_file_audioproperties(
      file,
    );
  }

  late final _taglib_file_audiopropertiesPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<TagLib_AudioProperties> Function(
              ffi.Pointer<TagLib_File>)>>('taglib_file_audioproperties');
  late final _taglib_file_audioproperties =
      _taglib_file_audiopropertiesPtr.asFunction<
          ffi.Pointer<TagLib_AudioProperties> Function(
              ffi.Pointer<TagLib_File>)>();

  /// !
  /// Saves the \a file to disk.
  int taglib_file_save(
    ffi.Pointer<TagLib_File> file,
  ) {
    return _taglib_file_save(
      file,
    );
  }

  late final _taglib_file_savePtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Pointer<TagLib_File>)>>(
          'taglib_file_save');
  late final _taglib_file_save =
      _taglib_file_savePtr.asFunction<int Function(ffi.Pointer<TagLib_File>)>();

  /// !
  /// Returns a string with this tag's title.
  ///
  /// \note By default this string should be UTF8 encoded and its memory should be
  /// freed using taglib_tag_free_strings().
  ffi.Pointer<ffi.Char> taglib_tag_title(
    ffi.Pointer<TagLib_Tag> tag,
  ) {
    return _taglib_tag_title(
      tag,
    );
  }

  late final _taglib_tag_titlePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<TagLib_Tag>)>>('taglib_tag_title');
  late final _taglib_tag_title = _taglib_tag_titlePtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<TagLib_Tag>)>();

  /// !
  /// Returns a string with this tag's artist.
  ///
  /// \note By default this string should be UTF8 encoded and its memory should be
  /// freed using taglib_tag_free_strings().
  ffi.Pointer<ffi.Char> taglib_tag_artist(
    ffi.Pointer<TagLib_Tag> tag,
  ) {
    return _taglib_tag_artist(
      tag,
    );
  }

  late final _taglib_tag_artistPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<TagLib_Tag>)>>('taglib_tag_artist');
  late final _taglib_tag_artist = _taglib_tag_artistPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<TagLib_Tag>)>();

  /// !
  /// Returns a string with this tag's album name.
  ///
  /// \note By default this string should be UTF8 encoded and its memory should be
  /// freed using taglib_tag_free_strings().
  ffi.Pointer<ffi.Char> taglib_tag_album(
    ffi.Pointer<TagLib_Tag> tag,
  ) {
    return _taglib_tag_album(
      tag,
    );
  }

  late final _taglib_tag_albumPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<TagLib_Tag>)>>('taglib_tag_album');
  late final _taglib_tag_album = _taglib_tag_albumPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<TagLib_Tag>)>();

  /// !
  /// Returns a string with this tag's comment.
  ///
  /// \note By default this string should be UTF8 encoded and its memory should be
  /// freed using taglib_tag_free_strings().
  ffi.Pointer<ffi.Char> taglib_tag_comment(
    ffi.Pointer<TagLib_Tag> tag,
  ) {
    return _taglib_tag_comment(
      tag,
    );
  }

  late final _taglib_tag_commentPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<TagLib_Tag>)>>('taglib_tag_comment');
  late final _taglib_tag_comment = _taglib_tag_commentPtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<TagLib_Tag>)>();

  /// !
  /// Returns a string with this tag's genre.
  ///
  /// \note By default this string should be UTF8 encoded and its memory should be
  /// freed using taglib_tag_free_strings().
  ffi.Pointer<ffi.Char> taglib_tag_genre(
    ffi.Pointer<TagLib_Tag> tag,
  ) {
    return _taglib_tag_genre(
      tag,
    );
  }

  late final _taglib_tag_genrePtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<ffi.Char> Function(
              ffi.Pointer<TagLib_Tag>)>>('taglib_tag_genre');
  late final _taglib_tag_genre = _taglib_tag_genrePtr
      .asFunction<ffi.Pointer<ffi.Char> Function(ffi.Pointer<TagLib_Tag>)>();

  /// !
  /// Returns the tag's year or 0 if year is not set.
  int taglib_tag_year(
    ffi.Pointer<TagLib_Tag> tag,
  ) {
    return _taglib_tag_year(
      tag,
    );
  }

  late final _taglib_tag_yearPtr = _lookup<
      ffi.NativeFunction<
          ffi.UnsignedInt Function(
              ffi.Pointer<TagLib_Tag>)>>('taglib_tag_year');
  late final _taglib_tag_year =
      _taglib_tag_yearPtr.asFunction<int Function(ffi.Pointer<TagLib_Tag>)>();

  /// !
  /// Returns the tag's track number or 0 if track number is not set.
  int taglib_tag_track(
    ffi.Pointer<TagLib_Tag> tag,
  ) {
    return _taglib_tag_track(
      tag,
    );
  }

  late final _taglib_tag_trackPtr = _lookup<
      ffi.NativeFunction<
          ffi.UnsignedInt Function(
              ffi.Pointer<TagLib_Tag>)>>('taglib_tag_track');
  late final _taglib_tag_track =
      _taglib_tag_trackPtr.asFunction<int Function(ffi.Pointer<TagLib_Tag>)>();

  /// !
  /// Sets the tag's title.
  ///
  /// \note By default this string should be UTF8 encoded.
  void taglib_tag_set_title(
    ffi.Pointer<TagLib_Tag> tag,
    ffi.Pointer<ffi.Char> title,
  ) {
    return _taglib_tag_set_title(
      tag,
      title,
    );
  }

  late final _taglib_tag_set_titlePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<TagLib_Tag>,
              ffi.Pointer<ffi.Char>)>>('taglib_tag_set_title');
  late final _taglib_tag_set_title = _taglib_tag_set_titlePtr.asFunction<
      void Function(ffi.Pointer<TagLib_Tag>, ffi.Pointer<ffi.Char>)>();

  /// !
  /// Sets the tag's artist.
  ///
  /// \note By default this string should be UTF8 encoded.
  void taglib_tag_set_artist(
    ffi.Pointer<TagLib_Tag> tag,
    ffi.Pointer<ffi.Char> artist,
  ) {
    return _taglib_tag_set_artist(
      tag,
      artist,
    );
  }

  late final _taglib_tag_set_artistPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<TagLib_Tag>,
              ffi.Pointer<ffi.Char>)>>('taglib_tag_set_artist');
  late final _taglib_tag_set_artist = _taglib_tag_set_artistPtr.asFunction<
      void Function(ffi.Pointer<TagLib_Tag>, ffi.Pointer<ffi.Char>)>();

  /// !
  /// Sets the tag's album.
  ///
  /// \note By default this string should be UTF8 encoded.
  void taglib_tag_set_album(
    ffi.Pointer<TagLib_Tag> tag,
    ffi.Pointer<ffi.Char> album,
  ) {
    return _taglib_tag_set_album(
      tag,
      album,
    );
  }

  late final _taglib_tag_set_albumPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<TagLib_Tag>,
              ffi.Pointer<ffi.Char>)>>('taglib_tag_set_album');
  late final _taglib_tag_set_album = _taglib_tag_set_albumPtr.asFunction<
      void Function(ffi.Pointer<TagLib_Tag>, ffi.Pointer<ffi.Char>)>();

  /// !
  /// Sets the tag's comment.
  ///
  /// \note By default this string should be UTF8 encoded.
  void taglib_tag_set_comment(
    ffi.Pointer<TagLib_Tag> tag,
    ffi.Pointer<ffi.Char> comment,
  ) {
    return _taglib_tag_set_comment(
      tag,
      comment,
    );
  }

  late final _taglib_tag_set_commentPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<TagLib_Tag>,
              ffi.Pointer<ffi.Char>)>>('taglib_tag_set_comment');
  late final _taglib_tag_set_comment = _taglib_tag_set_commentPtr.asFunction<
      void Function(ffi.Pointer<TagLib_Tag>, ffi.Pointer<ffi.Char>)>();

  /// !
  /// Sets the tag's genre.
  ///
  /// \note By default this string should be UTF8 encoded.
  void taglib_tag_set_genre(
    ffi.Pointer<TagLib_Tag> tag,
    ffi.Pointer<ffi.Char> genre,
  ) {
    return _taglib_tag_set_genre(
      tag,
      genre,
    );
  }

  late final _taglib_tag_set_genrePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<TagLib_Tag>,
              ffi.Pointer<ffi.Char>)>>('taglib_tag_set_genre');
  late final _taglib_tag_set_genre = _taglib_tag_set_genrePtr.asFunction<
      void Function(ffi.Pointer<TagLib_Tag>, ffi.Pointer<ffi.Char>)>();

  /// !
  /// Sets the tag's year.  0 indicates that this field should be cleared.
  void taglib_tag_set_year(
    ffi.Pointer<TagLib_Tag> tag,
    int year,
  ) {
    return _taglib_tag_set_year(
      tag,
      year,
    );
  }

  late final _taglib_tag_set_yearPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<TagLib_Tag>,
              ffi.UnsignedInt)>>('taglib_tag_set_year');
  late final _taglib_tag_set_year = _taglib_tag_set_yearPtr
      .asFunction<void Function(ffi.Pointer<TagLib_Tag>, int)>();

  /// !
  /// Sets the tag's track number.  0 indicates that this field should be cleared.
  void taglib_tag_set_track(
    ffi.Pointer<TagLib_Tag> tag,
    int track,
  ) {
    return _taglib_tag_set_track(
      tag,
      track,
    );
  }

  late final _taglib_tag_set_trackPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Pointer<TagLib_Tag>,
              ffi.UnsignedInt)>>('taglib_tag_set_track');
  late final _taglib_tag_set_track = _taglib_tag_set_trackPtr
      .asFunction<void Function(ffi.Pointer<TagLib_Tag>, int)>();

  /// !
  /// Frees all of the strings that have been created by the tag.
  void taglib_tag_free_strings() {
    return _taglib_tag_free_strings();
  }

  late final _taglib_tag_free_stringsPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function()>>(
          'taglib_tag_free_strings');
  late final _taglib_tag_free_strings =
      _taglib_tag_free_stringsPtr.asFunction<void Function()>();

  /// !
  /// Returns the length of the file in seconds.
  int taglib_audioproperties_length(
    ffi.Pointer<TagLib_AudioProperties> audioProperties,
  ) {
    return _taglib_audioproperties_length(
      audioProperties,
    );
  }

  late final _taglib_audioproperties_lengthPtr = _lookup<
          ffi.NativeFunction<
              ffi.Int Function(ffi.Pointer<TagLib_AudioProperties>)>>(
      'taglib_audioproperties_length');
  late final _taglib_audioproperties_length = _taglib_audioproperties_lengthPtr
      .asFunction<int Function(ffi.Pointer<TagLib_AudioProperties>)>();

  /// !
  /// Returns the bitrate of the file in kb/s.
  int taglib_audioproperties_bitrate(
    ffi.Pointer<TagLib_AudioProperties> audioProperties,
  ) {
    return _taglib_audioproperties_bitrate(
      audioProperties,
    );
  }

  late final _taglib_audioproperties_bitratePtr = _lookup<
          ffi.NativeFunction<
              ffi.Int Function(ffi.Pointer<TagLib_AudioProperties>)>>(
      'taglib_audioproperties_bitrate');
  late final _taglib_audioproperties_bitrate =
      _taglib_audioproperties_bitratePtr
          .asFunction<int Function(ffi.Pointer<TagLib_AudioProperties>)>();

  /// !
  /// Returns the sample rate of the file in Hz.
  int taglib_audioproperties_samplerate(
    ffi.Pointer<TagLib_AudioProperties> audioProperties,
  ) {
    return _taglib_audioproperties_samplerate(
      audioProperties,
    );
  }

  late final _taglib_audioproperties_sampleratePtr = _lookup<
          ffi.NativeFunction<
              ffi.Int Function(ffi.Pointer<TagLib_AudioProperties>)>>(
      'taglib_audioproperties_samplerate');
  late final _taglib_audioproperties_samplerate =
      _taglib_audioproperties_sampleratePtr
          .asFunction<int Function(ffi.Pointer<TagLib_AudioProperties>)>();

  /// !
  /// Returns the number of channels in the audio stream.
  int taglib_audioproperties_channels(
    ffi.Pointer<TagLib_AudioProperties> audioProperties,
  ) {
    return _taglib_audioproperties_channels(
      audioProperties,
    );
  }

  late final _taglib_audioproperties_channelsPtr = _lookup<
          ffi.NativeFunction<
              ffi.Int Function(ffi.Pointer<TagLib_AudioProperties>)>>(
      'taglib_audioproperties_channels');
  late final _taglib_audioproperties_channels =
      _taglib_audioproperties_channelsPtr
          .asFunction<int Function(ffi.Pointer<TagLib_AudioProperties>)>();

  /// !
  /// This sets the default encoding for ID3v2 frames that are written to tags.
  void taglib_id3v2_set_default_text_encoding(
    int encoding,
  ) {
    return _taglib_id3v2_set_default_text_encoding(
      encoding,
    );
  }

  late final _taglib_id3v2_set_default_text_encodingPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int32)>>(
          'taglib_id3v2_set_default_text_encoding');
  late final _taglib_id3v2_set_default_text_encoding =
      _taglib_id3v2_set_default_text_encodingPtr
          .asFunction<void Function(int)>();

  ffi.Pointer<MeipuruTag> MeipuruReadTag(
    ffi.Pointer<ffi.Char> filePath,
  ) {
    return _MeipuruReadTag(
      filePath,
    );
  }

  late final _MeipuruReadTagPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<MeipuruTag> Function(
              ffi.Pointer<ffi.Char>)>>('MeipuruReadTag');
  late final _MeipuruReadTag = _MeipuruReadTagPtr.asFunction<
      ffi.Pointer<MeipuruTag> Function(ffi.Pointer<ffi.Char>)>();

  ffi.Pointer<MeipuruID3v2Tag> MeipuruReadID3v2Tag(
    ffi.Pointer<ffi.Char> filePath,
  ) {
    return _MeipuruReadID3v2Tag(
      filePath,
    );
  }

  late final _MeipuruReadID3v2TagPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<MeipuruID3v2Tag> Function(
              ffi.Pointer<ffi.Char>)>>('MeipuruReadID3v2Tag');
  late final _MeipuruReadID3v2Tag = _MeipuruReadID3v2TagPtr.asFunction<
      ffi.Pointer<MeipuruID3v2Tag> Function(ffi.Pointer<ffi.Char>)>();

  void MeipuruFree(
    ffi.Pointer<ffi.Void> pointer,
  ) {
    return _MeipuruFree(
      pointer,
    );
  }

  late final _MeipuruFreePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>(
          'MeipuruFree');
  late final _MeipuruFree =
      _MeipuruFreePtr.asFunction<void Function(ffi.Pointer<ffi.Void>)>();
}

/// [ TagLib C Binding ]
///
/// This is an interface to TagLib's "simple" API, meaning that you can read and
/// modify media files in a generic, but not specialized way.  This is a rough
/// representation of TagLib::File and TagLib::Tag, for which the documentation
/// is somewhat more complete and worth consulting.
class TagLib_File extends ffi.Struct {
  @ffi.Int()
  external int dummy;
}

class TagLib_Tag extends ffi.Struct {
  @ffi.Int()
  external int dummy;
}

class TagLib_AudioProperties extends ffi.Struct {
  @ffi.Int()
  external int dummy;
}

/// File API
abstract class TagLib_File_Type {
  static const int TagLib_File_MPEG = 0;
  static const int TagLib_File_OggVorbis = 1;
  static const int TagLib_File_FLAC = 2;
  static const int TagLib_File_MPC = 3;
  static const int TagLib_File_OggFlac = 4;
  static const int TagLib_File_WavPack = 5;
  static const int TagLib_File_Speex = 6;
  static const int TagLib_File_TrueAudio = 7;
  static const int TagLib_File_MP4 = 8;
  static const int TagLib_File_ASF = 9;
}

/// Special convenience ID3v2 functions
abstract class TagLib_ID3v2_Encoding {
  static const int TagLib_ID3v2_Latin1 = 0;
  static const int TagLib_ID3v2_UTF16 = 1;
  static const int TagLib_ID3v2_UTF16BE = 2;
  static const int TagLib_ID3v2_UTF8 = 3;
}

class MeipuruTag extends ffi.Struct {
  external ffi.Pointer<ffi.Char> filePath;

  external ffi.Pointer<ffi.Char> fileName;

  external ffi.Pointer<ffi.Char> title;

  external ffi.Pointer<ffi.Char> artist;

  external ffi.Pointer<ffi.Char> albumTitle;

  external ffi.Pointer<ffi.Char> albumArtist;

  @ffi.UnsignedInt()
  external int year;

  @ffi.UnsignedInt()
  external int track;

  @ffi.Int()
  external int albumTotalTrack;

  external ffi.Pointer<ffi.Char> genre;

  external ffi.Pointer<ffi.Char> comment;

  @ffi.Int()
  external int bitRate;

  @ffi.Int()
  external int sampleRate;

  @ffi.Int()
  external int channels;

  @ffi.Int()
  external int length;
}

class MeipuruID3v2Tag extends ffi.Struct {
  external ffi.Pointer<ffi.Char> filePath;

  external ffi.Pointer<ffi.Char> fileName;

  external ffi.Pointer<ffi.Char> title;

  external ffi.Pointer<ffi.Char> artist;

  external ffi.Pointer<ffi.Char> albumTitle;

  external ffi.Pointer<ffi.Char> albumArtist;

  @ffi.UnsignedInt()
  external int year;

  @ffi.UnsignedInt()
  external int track;

  @ffi.Int()
  external int albumTotalTrack;

  external ffi.Pointer<ffi.Char> genre;

  external ffi.Pointer<ffi.Char> comment;

  @ffi.Int()
  external int bitRate;

  @ffi.Int()
  external int sampleRate;

  @ffi.Int()
  external int channels;

  @ffi.Int()
  external int length;

  external ffi.Pointer<ffi.Char> lyrics;

  @ffi.UnsignedLong()
  external int lyricsLength;

  external ffi.Pointer<ffi.Char> albumCover;

  @ffi.UnsignedInt()
  external int albumCoverLength;
}
