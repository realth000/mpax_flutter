import '../providers/storage_provider.dart';

/// Repository of all storage.
final class StorageRepository {
  StorageRepository(this._storageProvider);

  final StorageProvider _storageProvider;
}
