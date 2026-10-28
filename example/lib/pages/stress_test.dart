import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';

/// Fires many toasts at once to test stacking under load.
class StressTest extends StatelessWidget {
  /// Creates a stress test page.
  const StressTest({super.key});

  static const _types = ToastType.values;
  static const _messages = [
    'File uploaded',
    'Connection lost',
    'New message',
    'Task completed',
    'Warning detected',
    'Error occurred',
    'Data synced',
    'Update available',
    'Download complete',
    'Session expired',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Stress Test',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Fire many toasts to test stacking',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.bolt),
              label: const Text('Fire 10 Toasts'),
              onPressed: () => _fireToasts(10),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.flash_on),
              label: const Text('Fire 50 Toasts'),
              onPressed: () => _fireToasts(50),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.clear_all),
              label: const Text('Dismiss All'),
              onPressed: toast.dismissAll,
            ),
          ],
        ),
      ),
    );
  }

  void _fireToasts(int count) {
    final rng = Random();
    for (var i = 0; i < count; i++) {
      Future.delayed(Duration(milliseconds: i * 80), () {
        final type = _types[rng.nextInt(_types.length - 1)];
        final msg = _messages[rng.nextInt(_messages.length)];
        switch (type) {
          case ToastType.success:
            toast.success(msg);
          case ToastType.error:
            toast.error(msg);
          case ToastType.warning:
            toast.warning(msg);
          case ToastType.info:
            toast.info(msg);
          case ToastType.loading:
            final id = toast.loading(msg);
            Future.delayed(const Duration(seconds: 2), () => toast.dismiss(id));
          case ToastType.neutral:
            toast(msg);
        }
      });
    }
  }
}
