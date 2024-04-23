import '../../../shared/providers/storage_provider/storage_provider.dart';

/// Repository of all storage.
final class StorageRepository {
  StorageRepository(this._storageProvider);

  final StorageProvider _storageProvider;
}
