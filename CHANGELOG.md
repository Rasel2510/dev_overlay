# Changelog

## 1.0.2

- remove withOpacity and use WithValues

## 1.0.1

- Fixed `No Directionality widget found` error — wrapped overlay `Stack` with `Directionality`
- Removed incorrect `Navigator` inside the overlay that caused widget tree conflicts
- Tightened `device_info_plus` lower bound to `>=10.1.0`

## 1.0.0

- Initial release 🎉
- `DevOverlay` — one-widget setup, wraps your entire app
- Draggable panel — move anywhere on screen
- Tap to collapse/expand into a compact pill
- Shows:
  - Current route name
  - Screen size (logical pixels)
  - Device pixel ratio
  - Light/dark theme mode
  - Live FPS counter with color indicator (✅ ⚠️ ❌)
  - App version + build number
  - Device model name
  - OS name and version
- `enabled` flag — set to `kDebugMode` to auto-hide in release builds
- Customizable `backgroundColor` and `textColor`
- Customizable `initialPosition`
- Supports Android, iOS, macOS, Windows, Linux
