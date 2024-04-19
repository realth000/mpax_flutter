import 'package:flutter/material.dart';
import 'package:taglib_ffi_dart/taglib_ffi_dart.dart' as taglib;

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await taglib.initialize();

  runApp(const App());
}
