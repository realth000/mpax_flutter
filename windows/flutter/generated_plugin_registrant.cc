//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <sqlite3_flutter_libs/sqlite3_flutter_libs_plugin.h>
#include <taglib_ffi_dart_libs/taglib_ffi_dart_libs_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  Sqlite3FlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("Sqlite3FlutterLibsPlugin"));
  TaglibFfiDartLibsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TaglibFfiDartLibsPluginCApi"));
}
