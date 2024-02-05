import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_compression/image_compression.dart';
import 'package:mpax_flutter/utils/platform.dart';

Future<Uint8List> compressImage(Uint8List data) async {
  if (isMobile) {
    return FlutterImageCompress.compressWithList(
      data,
      minWidth: 120,
      minHeight: 120,
    );
  } else {
    final imageFile = compress(
      ImageFileConfiguration(
        input: ImageFile(
          filePath: '',
          rawBytes: data,
          width: 120,
          height: 120,
        ),
      ),
    );
    return imageFile.rawBytes;
  }
}
