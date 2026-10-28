import 'package:flutter/material.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';

/// Demonstrates all 6 toast positions.
class PositionDemo extends StatelessWidget {
  /// Creates a position demo page.
  const PositionDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Toast Positions',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.0,
              shrinkWrap: true,
              children: const [
                _PositionButton(
                  label: 'Top Left',
                  position: ToastPosition.topLeft,
                ),
                _PositionButton(
                  label: 'Top Center',
                  position: ToastPosition.topCenter,
                ),
                _PositionButton(
                  label: 'Top Right',
                  position: ToastPosition.topRight,
                ),
                _PositionButton(
                  label: 'Bottom Left',
                  position: ToastPosition.bottomLeft,
                ),
                _PositionButton(
                  label: 'Bottom Center',
                  position: ToastPosition.bottomCenter,
                ),
                _PositionButton(
                  label: 'Bottom Right',
                  position: ToastPosition.bottomRight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PositionButton extends StatelessWidget {
  const _PositionButton({
    required this.label,
    required this.position,
  });

  final String label;
  final ToastPosition position;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () => toast.success(
        label,
        description: 'Appears at ${position.name}',
        position: position,
      ),
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}
