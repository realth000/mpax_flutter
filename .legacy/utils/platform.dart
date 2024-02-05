import 'dart:io' show Platform;

final isDesktop = Platform.isWindows || Platform.isLinux || Platform.isMacOS;
final isMobile = Platform.isAndroid || Platform.isIOS;

final isWindows = Platform.isWindows;
final isLinux = Platform.isLinux;
final isMacOS = Platform.isMacOS;
final isAndroid = Platform.isAndroid;
final isIOS = Platform.isIOS;
