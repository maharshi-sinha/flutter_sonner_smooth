import 'package:flutter/material.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';

/// Demonstrates themed toasts with descriptions.
class ThemeDemo extends StatelessWidget {
  /// Creates a theme demo page.
  const ThemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Custom Theming',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Toasts inherit the auto light/dark theme,\nor use a custom theme via ToastLayer.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.palette),
              label: const Text('Success with Description'),
              onPressed: () => toast.success(
                'Payment received',
                description: r'$42.00 from jane@example.com via Stripe',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              icon: const Icon(Icons.warning_amber),
              label: const Text('Warning with Description'),
              onPressed: () => toast.warning(
                'Storage almost full',
                description: '90% of 10 GB used. Consider upgrading.',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text('Info with Description'),
              onPressed: () => toast.info(
                'Scheduled maintenance',
                description: 'Servers will restart at 3:00 AM UTC.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
