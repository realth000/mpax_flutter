part of 'schema.dart';

@RealmModel()
class _Artist {
  @PrimaryKey()
  late ObjectId id;

  late String name;
}
