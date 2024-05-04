import 'package:dart_mappable/dart_mappable.dart';
import 'package:drift/drift.dart';

part 'shared_model.mapper.dart';

/// Helper class to store a [Set] of int values.
@MappableClass(generateMethods: GenerateMethods.all)
class IntSet with IntSetMappable {
  /// Constructor.
  IntSet(this.values);

  /// A [Set] of int values.
  final Set<int> values;

  /// Converter definition.
  static JsonTypeConverter<IntSet, String> converter = TypeConverter.json(
    fromJson: (json) => IntSetMapper.fromJson(json as String),
    toJson: (entry) => entry.toJson(),
  );
}

/// Helper class to store a [Set] of string values.
@MappableClass(generateMethods: GenerateMethods.all)
class StringSet with StringSetMappable {
  /// Constructor.
  StringSet(this.values);

  /// A [Set] of [String] values.
  final Set<String> values;

  /// Converter definition.
  static JsonTypeConverter<StringSet, String> converter = TypeConverter.json(
    fromJson: (json) => StringSetMapper.fromJson(json as String),
    toJson: (entry) => entry.toJson(),
  );
}

/// Helper class to store a pair of [int] and [String] value.
@MappableClass(generateMethods: GenerateMethods.all)
class IntStringPair with IntStringPairMappable {
  /// Constructor.
  IntStringPair(this.intValue, this.stringValue);

  /// [int] value.
  final int intValue;

  /// [String] value.
  final String stringValue;

  /// Converter definition.
  static JsonTypeConverter<IntStringPair, String> converter =
      TypeConverter.json(
    fromJson: (json) => IntStringPairMapper.fromJson(json as String),
    toJson: (entry) => entry.toJson(),
  );
}

/// Helper class to store a [Set] of [IntStringPair] values.
@MappableClass(generateMethods: GenerateMethods.all)
class IntStringPairSet with IntStringPairSetMappable {
  /// Constructor.
  IntStringPairSet(this.values);

  /// A [Set] of [IntStringPair] values.
  final Set<IntStringPair> values;

  /// Converter definition.
  static JsonTypeConverter<IntStringPairSet, String> converter =
      TypeConverter.json(
    fromJson: (json) => IntStringPairSetMapper.fromJson(json as String),
    toJson: (entry) => entry.toJson(),
  );

  /// Remove all values in [values] where [IntStringPair.intValue] is
  /// [intValue].
  void removeByIntValue(int intValue) {
    values.removeWhere((x) => x.intValue == intValue);
  }

  /// Remove all values in [values] where [IntStringPair.intValue] exists
  /// in [intValueSet].
  void removeByIntValueSet(Set<int> intValueSet) {
    values.removeWhere((x) => intValueSet.contains(x.intValue));
  }

  /// Add value [intStringPair] into [values].
  void add(IntStringPair intStringPair) {
    values.add(intStringPair);
  }
}
