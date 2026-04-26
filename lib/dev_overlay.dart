import 'package:flutter/material.dart';

import 'src/inspector_overlay.dart';

export 'src/inspector_data.dart';
export 'src/inspector_overlay.dart';

/// A developer debug overlay for Flutter apps.
///
/// Wrap your app with [DevOverlay] to show a draggable debug panel
/// displaying route, screen size, theme, FPS, device info, and app version.
///
/// The overlay is automatically hidden in release builds when [enabled] is
/// set to `kDebugMode`.
///
/// ## Quick Start
/// ```dart
/// import 'package:flutter/foundation.dart';
/// import 'package:dev_overlay/dev_overlay.dart';
///
/// void main() {
///   runApp(
///     DevOverlay(
///       enabled: kDebugMode,
///       child: const MyApp(),
///     ),
///   );
/// }
/// ```
///
/// ## Custom Colors
/// ```dart
/// DevOverlay(
///   enabled: kDebugMode,
///   backgroundColor: Colors.black87,
///   textColor: Colors.greenAccent,
///   child: const MyApp(),
/// )
/// ```
///
/// ## Custom Position
/// ```dart
/// DevOverlay(
///   enabled: kDebugMode,
///   initialPosition: Offset(8, 120),
///   child: const MyApp(),
/// )
/// ```
class DevOverlay extends StatelessWidget {
  /// The app widget to wrap.
  final Widget child;

  /// Whether the inspector is visible.
  ///
  /// Set to `kDebugMode` to automatically hide in release builds:
  /// ```dart
  /// enabled: kDebugMode,
  /// ```
  final bool enabled;

  /// Background color of the inspector panel.
  ///
  /// Defaults to semi-transparent black.
  final Color? backgroundColor;

  /// Text and icon color of the inspector panel.
  ///
  /// Defaults to bright green `#00FF88`.
  final Color? textColor;

  /// Initial position of the draggable panel.
  ///
  /// Defaults to `Offset(8, 80)` — top left below the status bar.
  final Offset initialPosition;

  /// Creates a [DevOverlay] widget.
  const DevOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.initialPosition = const Offset(8, 80),
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return DevOverlayPanel(
      backgroundColor: backgroundColor,
      textColor: textColor,
      initialPosition: initialPosition,
      child: child,
    );
  }
}
