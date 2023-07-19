import 'dart:io';

/// Walk through functions extension on [Directory].
extension WalkThrough on Directory {
  /// List all directories and files under this [Directory].
  Future<List<FileSystemEntity>> listAll() async {
    final es = await list().toList();
    final sub = <FileSystemEntity>[];
    for (final e in es) {
      if (e.statSync().type == FileSystemEntityType.directory) {
        sub.addAll(await Directory(e.path).listAll());
      }
    }
    es.addAll(sub);
    return es;
  }
}

String saveBase64Picture(String data) {
  return '';
}
