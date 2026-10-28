# flutter_sonner_smooth

> A Sonner-inspired, buttery-smooth toast notification system for Flutter.

[![pub version](https://img.shields.io/pub/v/flutter_sonner_smooth.svg)](https://pub.dev/packages/flutter_sonner_smooth)
[![pub points](https://img.shields.io/pub/points/flutter_sonner_smooth)](https://pub.dev/packages/flutter_sonner_smooth/score)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/maharshi-sinha/flutter_sonner_smooth/blob/main/LICENSE)
[![flutter](https://img.shields.io/badge/flutter-%3E%3D3.19.0-blue.svg)](https://flutter.dev)

## Demo

<table>
  <tr>
    <td align="center"><strong>Basic Toasts</strong></td>
    <td align="center"><strong>Promise API</strong></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/maharshi-sinha/flutter_sonner_smooth/main/assets/basic_demo.gif" width="300"/></td>
    <td><img src="https://raw.githubusercontent.com/maharshi-sinha/flutter_sonner_smooth/main/assets/promise_demo.gif" width="300"/></td>
  </tr>
  <tr>
    <td align="center"><strong>Positions</strong></td>
    <td align="center"><strong>Theming</strong></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/maharshi-sinha/flutter_sonner_smooth/main/assets/positions_demo.webp" width="300"/></td>
    <td><img src="https://raw.githubusercontent.com/maharshi-sinha/flutter_sonner_smooth/main/assets/theme_demo.gif" width="300"/></td>
  </tr>
  <tr>
    <td align="center" colspan="2"><strong>Stress Test (50 toasts)</strong></td>
  </tr>
  <tr>
    <td align="center" colspan="2"><img src="https://raw.githubusercontent.com/maharshi-sinha/flutter_sonner_smooth/main/assets/stress_test.webp" width="300"/></td>
  </tr>
</table>

## Features

- **Zero config** -- mount one widget, call from anywhere
- **Spring physics** -- every animation uses real physics, not easing curves
- **Promise API** -- `toast.promise(future)` auto-swaps loading -> success/error
- **Context-free** -- no `BuildContext` ever needed
- **Smart stacking** -- collapsed stack, expand on hover
- **Swipe to dismiss** -- natural gesture with velocity
- **Fully themeable** -- light/dark auto, every color overridable
- **Progress bar** -- auto-dismiss timer with pause-on-hover
- **Zero dependencies** -- pure Flutter, nothing else
- **All 6 platforms** -- iOS, Android, Web, macOS, Windows, Linux

## Install

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_sonner_smooth: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Import

```dart
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';
```

### 2. Wrap your app

Add `ToastLayer` in your `MaterialApp.builder` -- this is the only setup needed:

```dart
MaterialApp(
  builder: (context, child) => ToastLayer(child: child!),
  home: const HomePage(),
);
```

### 3. Show toasts from anywhere

```dart
toast('Hello world');
```

No `BuildContext`. No `ScaffoldMessenger`. Just call `toast`.

## API Reference

### Toast Types

```dart
// Neutral -- no icon
toast('Hello world');

// Success -- green check icon
toast.success('Changes saved');

// Error -- red alert icon (6s default duration)
toast.error('Something went wrong');

// Warning -- amber warning icon
toast.warning('Careful with that');

// Info -- blue info icon
toast.info('FYI, something happened');

// Loading -- spinner, no auto-dismiss
final id = toast.loading('Processing...');
```

Every method returns a `String` id you can use to dismiss or update the toast later.

### With Description

```dart
toast.success(
  'Payment received',
  description: r'$42.00 from jane@example.com',
);

toast.error(
  'Upload failed',
  description: 'File exceeds 10 MB limit. Try compressing it.',
);
```

### Custom Duration

```dart
// Short 2-second toast
toast('Quick note', duration: const Duration(seconds: 2));

// Long 10-second toast
toast.warning('Read this carefully', duration: const Duration(seconds: 10));
```

Default durations: 4 seconds for most types, 6 seconds for errors, infinite for loading.

### Promise API

The hero feature. Show a loading toast, then auto-swap to success or error when the `Future` completes:

```dart
toast.promise(
  uploadFile(),
  loading: 'Uploading...',
  success: (url) => 'Uploaded to $url',
  error: (e) => 'Upload failed: $e',
);
```

Works with any `Future<T>`. The `success` callback receives the resolved value, `error` receives the thrown object.

### Dismiss

```dart
// Dismiss a specific toast
final id = toast.loading('Working...');
await doWork();
toast.dismiss(id);

// Dismiss everything
toast.dismissAll();
```

### Update

Change a toast's content while it's visible:

```dart
final id = toast('Step 1 of 3...');

await step1();
toast.update(id, message: 'Step 2 of 3...');

await step2();
toast.update(id, message: 'Step 3 of 3...');

await step3();
toast.update(id, message: 'All done!', type: ToastType.success);
```

You can update `message`, `description`, `type`, and `duration`.

### onDismissed Callback

Run code when a toast is dismissed (by timeout, swipe, or programmatic dismiss):

```dart
toast.success(
  'File deleted',
  onDismissed: () => print('Toast gone'),
);
```

### Custom Position

Override position per toast:

```dart
toast.success('Top left!', position: ToastPosition.topLeft);
toast.error('Bottom center!', position: ToastPosition.bottomCenter);
```

## Positions

Six positions supported:

| | Left | Center | Right |
|---|---|---|---|
| **Top** | `topLeft` | `topCenter` | `topRight` |
| **Bottom** | `bottomLeft` | `bottomCenter` | `bottomRight` |

Set a default on `ToastLayer`:

```dart
ToastLayer(
  position: ToastPosition.bottomCenter,
  child: child!,
)
```

Or override per toast:

```dart
toast.success('Here!', position: ToastPosition.topLeft);
```

## ToastLayer Configuration

`ToastLayer` accepts these parameters to customize behavior globally:

```dart
ToastLayer(
  // Default position for all toasts (default: topRight)
  position: ToastPosition.topRight,

  // Max visible toasts per position before older ones collapse (default: 3)
  maxVisible: 5,

  // Gap between collapsed toasts in pixels (default: 8)
  gap: 8.0,

  // Gap between expanded toasts on hover in pixels (default: 12)
  expandedGap: 12.0,

  // Outer margin from screen edges (default: 16 all sides)
  margin: const EdgeInsets.all(24),

  // Swipe direction: auto, horizontal, vertical, or none (default: auto)
  swipeDirection: SwipeDirection.horizontal,

  // Whether to expand the stack on hover -- desktop/web (default: true)
  expandOnHover: true,

  // Custom theme (auto light/dark if null)
  theme: ToastThemeData.dark(),

  child: child!,
)
```

### Swipe Directions

| Value | Behavior |
|---|---|
| `SwipeDirection.auto` | Horizontal on desktop/web, vertical on mobile |
| `SwipeDirection.horizontal` | Always swipe left/right to dismiss |
| `SwipeDirection.vertical` | Always swipe up/down to dismiss |
| `SwipeDirection.none` | Disable swipe dismiss |

## Theming

Toasts auto-detect light/dark mode from `MediaQuery.platformBrightnessOf`. To override:

```dart
// Force dark theme
ToastLayer(
  theme: ToastThemeData.dark(),
  child: child!,
)

// Customize specific colors
ToastLayer(
  theme: ToastThemeData.light().copyWith(
    successColor: Colors.teal,
    errorColor: Colors.deepOrange,
    borderRadius: 20,
    maxWidth: 400,
  ),
  child: child!,
)

// Fully custom theme
ToastLayer(
  theme: ToastThemeData(
    backgroundColor: const Color(0xFF1A1A2E),
    borderColor: const Color(0x1AFFFFFF),
    textColor: const Color(0xFFEEEEEE),
    descriptionColor: const Color(0xFF999999),
    successColor: const Color(0xFF00D9A6),
    errorColor: const Color(0xFFFF6B6B),
    warningColor: const Color(0xFFFFD93D),
    infoColor: const Color(0xFF4ECDC4),
    borderRadius: 16,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    maxWidth: 380,
    minWidth: 300,
    messageStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    descriptionStyle: const TextStyle(fontSize: 13),
    shadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 32)],
  ),
  child: child!,
)
```

### Theme Properties

| Property | Type | Description |
|---|---|---|
| `backgroundColor` | `Color` | Toast card background |
| `borderColor` | `Color` | Hairline border color |
| `textColor` | `Color` | Primary message text color |
| `descriptionColor` | `Color` | Secondary description text color |
| `successColor` | `Color` | Accent for success toasts |
| `errorColor` | `Color` | Accent for error toasts |
| `warningColor` | `Color` | Accent for warning toasts |
| `infoColor` | `Color` | Accent for info toasts |
| `borderRadius` | `double` | Corner radius |
| `padding` | `EdgeInsets` | Inner padding |
| `maxWidth` | `double` | Maximum toast width |
| `minWidth` | `double` | Minimum toast width |
| `messageStyle` | `TextStyle` | Message text style |
| `descriptionStyle` | `TextStyle` | Description text style |
| `shadow` | `List<BoxShadow>` | Card shadow |

### Access Theme in Widgets

```dart
final theme = ToastTheme.of(context);
```

## How It Works

### Spring Physics

Every animation uses `SpringSimulation` with hand-tuned constants:

| Animation | Stiffness | Damping |
|---|---|---|
| Enter | 180 | 20 |
| Exit | 240 | 24 |
| Stack shift | 200 | 22 |

No cubic beziers. No `Curves.easeInOut`. The result is motion that feels alive -- toasts settle into place, respond to swipes with momentum, and transition between states organically.

### Smart Stacking

Toasts stack in a collapsed view showing the top 3 (configurable with `maxVisible`). On hover (desktop/web), the stack smoothly expands to show all toasts. Each toast in the stack has progressively reduced scale and opacity for a natural depth effect.

### Swipe to Dismiss

Swipe gestures use velocity detection:
- **Fast swipe** (> 500px/s): immediate dismiss
- **Drag past threshold** (> 80px): dismiss on release
- **Short drag**: springs back to position

### Progress Bar

Each auto-dismissing toast shows a progress bar that counts down. Hover over a toast to pause the timer -- the progress bar freezes and resumes when the cursor leaves.

## Example App

Run the included example:

```bash
cd example
flutter run
```

The example app includes 5 demo pages:
- **Basic** -- all 6 toast types
- **Promise** -- simulated async operations
- **Positions** -- all 6 position options
- **Theme** -- toasts with descriptions
- **Stress** -- fire 10 or 50 toasts at once

## Comparison

| Feature | flutter_sonner_smooth | fluttertoast | motion_toast |
|---|---|---|---|
| Context-free | Yes | No | No |
| Promise API | Yes | No | No |
| Spring physics | Yes | No | No |
| Smart stacking | Yes | No | Partial |
| Swipe dismiss | Yes | No | No |
| Progress bar | Yes | No | No |
| Update in-place | Yes | No | No |
| Zero deps | Yes | No | No |
| Web support | Yes | Partial | Yes |

## Requirements

- Dart SDK `>=3.3.0 <4.0.0`
- Flutter `>=3.19.0`

## Credits

Inspired by [Sonner](https://sonner.emilkowal.ski) by Emil Kowalski.

## License

MIT -- see [LICENSE](LICENSE) for details.
