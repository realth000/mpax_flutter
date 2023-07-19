// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Settings {
  String get currentMediaPath => throw _privateConstructorUsedError;
  int get currentPlaylistId => throw _privateConstructorUsedError;
  String get playMode => throw _privateConstructorUsedError;
  bool get useDarkTheme => throw _privateConstructorUsedError;
  bool get followSystemTheme => throw _privateConstructorUsedError;
  int get volume => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res, Settings>;
  @useResult
  $Res call(
      {String currentMediaPath,
      int currentPlaylistId,
      String playMode,
      bool useDarkTheme,
      bool followSystemTheme,
      int volume});
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res, $Val extends Settings>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMediaPath = null,
    Object? currentPlaylistId = null,
    Object? playMode = null,
    Object? useDarkTheme = null,
    Object? followSystemTheme = null,
    Object? volume = null,
  }) {
    return _then(_value.copyWith(
      currentMediaPath: null == currentMediaPath
          ? _value.currentMediaPath
          : currentMediaPath // ignore: cast_nullable_to_non_nullable
              as String,
      currentPlaylistId: null == currentPlaylistId
          ? _value.currentPlaylistId
          : currentPlaylistId // ignore: cast_nullable_to_non_nullable
              as int,
      playMode: null == playMode
          ? _value.playMode
          : playMode // ignore: cast_nullable_to_non_nullable
              as String,
      useDarkTheme: null == useDarkTheme
          ? _value.useDarkTheme
          : useDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      followSystemTheme: null == followSystemTheme
          ? _value.followSystemTheme
          : followSystemTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$$_SettingsCopyWith(
          _$_Settings value, $Res Function(_$_Settings) then) =
      __$$_SettingsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String currentMediaPath,
      int currentPlaylistId,
      String playMode,
      bool useDarkTheme,
      bool followSystemTheme,
      int volume});
}

/// @nodoc
class __$$_SettingsCopyWithImpl<$Res>
    extends _$SettingsCopyWithImpl<$Res, _$_Settings>
    implements _$$_SettingsCopyWith<$Res> {
  __$$_SettingsCopyWithImpl(
      _$_Settings _value, $Res Function(_$_Settings) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentMediaPath = null,
    Object? currentPlaylistId = null,
    Object? playMode = null,
    Object? useDarkTheme = null,
    Object? followSystemTheme = null,
    Object? volume = null,
  }) {
    return _then(_$_Settings(
      currentMediaPath: null == currentMediaPath
          ? _value.currentMediaPath
          : currentMediaPath // ignore: cast_nullable_to_non_nullable
              as String,
      currentPlaylistId: null == currentPlaylistId
          ? _value.currentPlaylistId
          : currentPlaylistId // ignore: cast_nullable_to_non_nullable
              as int,
      playMode: null == playMode
          ? _value.playMode
          : playMode // ignore: cast_nullable_to_non_nullable
              as String,
      useDarkTheme: null == useDarkTheme
          ? _value.useDarkTheme
          : useDarkTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      followSystemTheme: null == followSystemTheme
          ? _value.followSystemTheme
          : followSystemTheme // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_Settings implements _Settings {
  const _$_Settings(
      {required this.currentMediaPath,
      required this.currentPlaylistId,
      required this.playMode,
      required this.useDarkTheme,
      required this.followSystemTheme,
      required this.volume});

  @override
  final String currentMediaPath;
  @override
  final int currentPlaylistId;
  @override
  final String playMode;
  @override
  final bool useDarkTheme;
  @override
  final bool followSystemTheme;
  @override
  final int volume;

  @override
  String toString() {
    return 'Settings(currentMediaPath: $currentMediaPath, currentPlaylistId: $currentPlaylistId, playMode: $playMode, useDarkTheme: $useDarkTheme, followSystemTheme: $followSystemTheme, volume: $volume)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Settings &&
            (identical(other.currentMediaPath, currentMediaPath) ||
                other.currentMediaPath == currentMediaPath) &&
            (identical(other.currentPlaylistId, currentPlaylistId) ||
                other.currentPlaylistId == currentPlaylistId) &&
            (identical(other.playMode, playMode) ||
                other.playMode == playMode) &&
            (identical(other.useDarkTheme, useDarkTheme) ||
                other.useDarkTheme == useDarkTheme) &&
            (identical(other.followSystemTheme, followSystemTheme) ||
                other.followSystemTheme == followSystemTheme) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentMediaPath,
      currentPlaylistId, playMode, useDarkTheme, followSystemTheme, volume);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SettingsCopyWith<_$_Settings> get copyWith =>
      __$$_SettingsCopyWithImpl<_$_Settings>(this, _$identity);
}

abstract class _Settings implements Settings {
  const factory _Settings(
      {required final String currentMediaPath,
      required final int currentPlaylistId,
      required final String playMode,
      required final bool useDarkTheme,
      required final bool followSystemTheme,
      required final int volume}) = _$_Settings;

  @override
  String get currentMediaPath;
  @override
  int get currentPlaylistId;
  @override
  String get playMode;
  @override
  bool get useDarkTheme;
  @override
  bool get followSystemTheme;
  @override
  int get volume;
  @override
  @JsonKey(ignore: true)
  _$$_SettingsCopyWith<_$_Settings> get copyWith =>
      throw _privateConstructorUsedError;
}
