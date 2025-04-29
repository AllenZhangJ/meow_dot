//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import flutter_local_notifications
import hotkey_manager_macos
import package_info_plus
import path_provider_foundation
import screen_retriever
import shared_preferences_foundation
import system_tray
import url_launcher_macos
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FlutterLocalNotificationsPlugin.register(with: registry.registrar(forPlugin: "FlutterLocalNotificationsPlugin"))
  HotkeyManagerMacosPlugin.register(with: registry.registrar(forPlugin: "HotkeyManagerMacosPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ScreenRetrieverPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SystemTrayPlugin.register(with: registry.registrar(forPlugin: "SystemTrayPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
