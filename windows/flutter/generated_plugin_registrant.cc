//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_media_metadata/flutter_media_metadata_plugin.h>
#include <metadata_god/metadata_god_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterMediaMetadataPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterMediaMetadataPlugin"));
  MetadataGodPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MetadataGodPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
