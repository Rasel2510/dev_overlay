import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Holds all debug information shown by [DevOverlay].
class InspectorData {
  /// Current route name.
  final String route;

  /// Screen width in logical pixels.
  final double screenWidth;

  /// Screen height in logical pixels.
  final double screenHeight;

  /// Current theme brightness.
  final Brightness brightness;

  /// App version string e.g. `1.0.0`.
  final String appVersion;

  /// App build number e.g. `7`.
  final String buildNumber;

  /// Device model name.
  final String deviceName;

  /// OS name and version.
  final String osVersion;

  /// Creates an [InspectorData] instance.
  const InspectorData({
    required this.route,
    required this.screenWidth,
    required this.screenHeight,
    required this.brightness,
    required this.appVersion,
    required this.buildNumber,
    required this.deviceName,
    required this.osVersion,
  });

  /// Loads device and app info asynchronously.
  static Future<Map<String, String>> loadStaticInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfoPlugin = DeviceInfoPlugin();

    String deviceName = 'Unknown';
    String osVersion = 'Unknown';

    try {
      if (Platform.isAndroid) {
        final info = await deviceInfoPlugin.androidInfo;
        deviceName = '${info.manufacturer} ${info.model}';
        osVersion = 'Android ${info.version.release}';
      } else if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        deviceName = info.utsname.machine;
        osVersion = '${info.systemName} ${info.systemVersion}';
      } else if (Platform.isMacOS) {
        final info = await deviceInfoPlugin.macOsInfo;
        deviceName = info.model;
        osVersion = 'macOS ${info.osRelease}';
      } else if (Platform.isWindows) {
        final info = await deviceInfoPlugin.windowsInfo;
        deviceName = info.computerName;
        osVersion = 'Windows ${info.displayVersion}';
      } else if (Platform.isLinux) {
        final info = await deviceInfoPlugin.linuxInfo;
        deviceName = info.name;
        osVersion = info.version ?? 'Linux';
      }
    } catch (_) {}

    return {
      'appVersion': packageInfo.version,
      'buildNumber': packageInfo.buildNumber,
      'deviceName': deviceName,
      'osVersion': osVersion,
    };
  }
}
