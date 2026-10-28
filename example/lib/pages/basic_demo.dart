import 'package:flutter/material.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';

/// Demonstrates basic toast types.
class BasicDemo extends StatelessWidget {
  /// Creates a basic demo page.
  const BasicDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            _DemoButton(
              label: 'Neutral',
              color: cs.surfaceContainerHighest,
              textColor: cs.onSurface,
              onPressed: () => toast('This is a neutral toast'),
            ),
            _DemoButton(
              label: 'Success',
              color: const Color(0xFF10B981),
              onPressed: () => toast.success(
                'Changes saved',
                description: 'Your profile has been updated.',
              ),
            ),
            _DemoButton(
              label: 'Error',
              color: const Color(0xFFEF4444),
              onPressed: () => toast.error(
                'Something went wrong',
                description: 'Please try again later.',
              ),
            ),
            _DemoButton(
              label: 'Warning',
              color: const Color(0xFFF59E0B),
              onPressed: () => toast.warning(
                'Rate limit approaching',
                description: '80% of quota used.',
              ),
            ),
            _DemoButton(
              label: 'Info',
              color: const Color(0xFF3B82F6),
              onPressed: () => toast.info(
                'New version available',
                description: 'v2.0 is ready to install.',
              ),
            ),
            _DemoButton(
              label: 'Loading',
              color: cs.secondary,
              onPressed: () {
                final id = toast.loading('Processing...');
                Future.delayed(const Duration(seconds: 2), () {
                  toast.dismiss(id);
                  toast.success('Done!');
                });
              },
            ),
            _DemoButton(
              label: 'Dismiss All',
              color: cs.error,
              onPressed: toast.dismissAll,
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  const _DemoButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.textColor,
  });

  final String label;
  final Color color;
  final Color? textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
