//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <audioplayers_windows/audioplayers_windows_plugin.h>
#include <bitsdojo_window_windows/bitsdojo_window_plugin.h>
#include <hotkey_manager/hotkey_manager_plugin.h>
#include <metadata_god/metadata_god_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AudioplayersWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AudioplayersWindowsPlugin"));
  BitsdojoWindowPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("BitsdojoWindowPlugin"));
  HotkeyManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("HotkeyManagerPlugin"));
  MetadataGodPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MetadataGodPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
