/// A Sonner-inspired, buttery-smooth toast notification system for Flutter.
///
/// Zero dependencies, context-free, promise-aware, physics-animated.
///
/// ## Quick start
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ToastLayer(child: child!),
///   home: const HomePage(),
/// );
/// ```
///
/// Then call from anywhere:
///
/// ```dart
/// toast('Hello');
/// toast.success('Saved');
/// toast.promise(future, loading: '...', success: (_) => '...', error: (_) => '...');
/// ```
library;

export 'src/toast.dart' show Toast, toast;
export 'src/toast_entry.dart' show ToastEntry;
export 'src/toast_layer.dart' show ToastLayer;
export 'src/toast_theme.dart' show ToastTheme, ToastThemeData;
export 'src/toast_types.dart';
