import 'package:flutter/material.dart';

import 'fps_counter.dart';
import 'inspector_data.dart';

/// The draggable inspector overlay widget.
///
/// Wraps your app and shows a debug panel with route, screen size,
/// theme, FPS, device and app version info.
class DevOverlayPanel extends StatefulWidget {
  /// The child widget (your app).
  final Widget child;

  /// The background color of the inspector panel.
  final Color? backgroundColor;

  /// The text color of the inspector panel.
  final Color? textColor;

  /// Initial position of the panel.
  final Offset initialPosition;

  /// Creates an [DevOverlayPanel].
  const DevOverlayPanel({
    super.key,
    required this.child,
    this.backgroundColor,
    this.textColor,
    this.initialPosition = const Offset(8, 80),
  });

  @override
  State<DevOverlayPanel> createState() => _DevOverlayPanelState();
}

class _DevOverlayPanelState extends State<DevOverlayPanel> {
  late Offset _position;
  bool _collapsed = false;
  double _fps = 0;
  String _route = '/';
  Map<String, String> _staticInfo = {};
  final FpsCounter _fpsCounter = FpsCounter();

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    _fpsCounter.start((fps) {
      if (mounted) setState(() => _fps = fps);
    });
    _loadStaticInfo();
  }

  Future<void> _loadStaticInfo() async {
    final info = await InspectorData.loadStaticInfo();
    if (mounted) setState(() => _staticInfo = info);
  }

  @override
  void dispose() {
    _fpsCounter.stop();
    super.dispose();
  }

  Color get _bg =>
      widget.backgroundColor ?? const Color(0xE6000000);

  Color get _fg => widget.textColor ?? const Color(0xFF00FF88);

  Color get _dim => _fg.withOpacity(0.5);

  String get _fpsLabel {
    if (_fps >= 55) return '${_fps.toStringAsFixed(0)}fps ✅';
    if (_fps >= 30) return '${_fps.toStringAsFixed(0)}fps ⚠️';
    return '${_fps.toStringAsFixed(0)}fps ❌';
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final brightness = Theme.of(context).brightness;
    final route = ModalRoute.of(context)?.settings.name ?? _route;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          // ─── Main app ───────────────────────────────────────────────────
          widget.child,

          // ─── Draggable overlay ──────────────────────────────────────────
          Positioned(
            left: _position.dx,
            top: _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                });
              },
              child: Material(
                color: Colors.transparent,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _fg.withOpacity(0.3), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                ),
                child: _collapsed
                    ? _buildCollapsed()
                    : _buildExpanded(
                        route: route,
                        media: media,
                        brightness: brightness,
                      ),
              ),
            ),
          ),
        ),
      ],
    ),
    );
  }

  // ─── Collapsed pill ──────────────────────────────────────────────────────

  Widget _buildCollapsed() {
    return GestureDetector(
      onTap: () => setState(() => _collapsed = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bug_report, color: _fg, size: 14),
            const SizedBox(width: 4),
            Text(
              _fpsLabel,
              style: TextStyle(
                color: _fg,
                fontSize: 10,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Expanded panel ──────────────────────────────────────────────────────

  Widget _buildExpanded({
    required String route,
    required MediaQueryData media,
    required Brightness brightness,
  }) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _collapsed = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _fg.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Icon(Icons.bug_report, color: _fg, size: 12),
                  const SizedBox(width: 6),
                  Text(
                    'FLUTTER INSPECTOR',
                    style: TextStyle(
                      color: _fg,
                      fontSize: 9,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.remove, color: _dim, size: 12),
                ],
              ),
            ),
          ),

          // Divider
          Divider(height: 1, color: _fg.withOpacity(0.2)),

          // Rows
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _row('ROUTE', route),
                _row('SCREEN',
                    '${media.size.width.toInt()} × ${media.size.height.toInt()}'),
                _row('PIXEL RATIO', media.devicePixelRatio.toStringAsFixed(2)),
                _row('THEME',
                    brightness == Brightness.dark ? '🌙 dark' : '☀️ light'),
                _row('FPS', _fpsLabel),
                if (_staticInfo.isNotEmpty) ...[
                  _row('VERSION',
                      '${_staticInfo['appVersion']}+${_staticInfo['buildNumber']}'),
                  _row('DEVICE', _staticInfo['deviceName'] ?? '—'),
                  _row('OS', _staticInfo['osVersion'] ?? '—'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(
              label,
              style: TextStyle(
                color: _dim,
                fontSize: 9,
                fontFamily: 'monospace',
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: _fg,
                fontSize: 9,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
