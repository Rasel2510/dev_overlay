# dev_overlay

A developer debug overlay for Flutter apps. Shows route, screen size, theme, FPS, device info and app version — all in a draggable panel directly on your screen.

## Preview

```
┌─────────────────────────────┐
│ 🐛 FLUTTER INSPECTOR      — │
├─────────────────────────────┤
│ ROUTE      /home            │
│ SCREEN     412 × 892        │
│ PIXEL RATIO 3.00            │
│ THEME      🌙 dark          │
│ FPS        60fps ✅         │
│ VERSION    1.0.0+7          │
│ DEVICE     Pixel 7 Pro      │
│ OS         Android 14       │
└─────────────────────────────┘
```

## Installation

```yaml
dependencies:
  dev_overlay: ^1.0.2
```

## Usage

Wrap your app with `DevOverlay`:

```dart
import 'package:flutter/foundation.dart';
import 'package:dev_overlay/dev_overlay.dart';

void main() {
  runApp(
    DevOverlay(
      enabled: kDebugMode, // auto-hides in release builds
      child: const MyApp(),
    ),
  );
}
```

That's it! The inspector panel appears in the top-left corner.

## Features

- **Draggable** — move the panel anywhere on screen
- **Collapsible** — tap to collapse into a compact pill
- **Auto-hide** — set `enabled: kDebugMode` to hide in release
- **Live FPS** — color coded: ✅ 60fps / ⚠️ 30fps / ❌ below 30fps
- **Route tracking** — updates as you navigate between pages
- **Device info** — model name and OS version
- **App info** — version and build number
- **Screen info** — logical pixels and device pixel ratio
- **Theme** — shows light/dark mode

## Customization

```dart
DevOverlay(
  enabled: kDebugMode,
  backgroundColor: Colors.black87,        // panel background
  textColor: Colors.greenAccent,          // text and icon color
  initialPosition: const Offset(8, 120),  // starting position
  child: const MyApp(),
)
```

## Platform Support

| Android | iOS | macOS | Windows | Linux |
|:-------:|:---:|:-----:|:-------:|:-----:|
| ✅ | ✅ | ✅ | ✅ | ✅ |
