import 'package:flutter/scheduler.dart';

/// Tracks frames per second using [SchedulerBinding].
class FpsCounter {
  final List<Duration> _frameTimes = [];
  late final Ticker _ticker;
  double _fps = 0;
  Duration _lastTime = Duration.zero;

  /// Current FPS value.
  double get fps => _fps;

  /// Starts tracking FPS, calling [onUpdate] each frame.
  void start(void Function(double fps) onUpdate) {
    _ticker = Ticker((elapsed) {
      final delta = elapsed - _lastTime;
      _lastTime = elapsed;

      if (delta.inMilliseconds > 0) {
        _frameTimes.add(delta);
        if (_frameTimes.length > 60) _frameTimes.removeAt(0);

        final avgMs = _frameTimes
                .map((d) => d.inMicroseconds)
                .reduce((a, b) => a + b) /
            _frameTimes.length;

        _fps = avgMs > 0 ? (1000000 / avgMs).clamp(0, 120) : 0;
        onUpdate(_fps);
      }
    });
    _ticker.start();
  }

  /// Stops the FPS ticker.
  void stop() {
    _ticker.stop();
    _ticker.dispose();
  }
}
