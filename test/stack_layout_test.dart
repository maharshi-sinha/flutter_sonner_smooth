import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';
import 'package:flutter_sonner_smooth/src/internal/stack_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StackLayout', () {
    test('collapsed: index 0 has full scale and opacity', () {
      final t = StackLayout.compute(
        index: 0,
        totalVisible: 3,
        expanded: false,
        toastHeight: 60,
        gap: 8,
        expandedGap: 12,
        position: ToastPosition.topRight,
      );
      expect(t.scale, 1.0);
      expect(t.opacity, 1.0);
      expect(t.offset.dy, 0.0);
    });

    test('collapsed: index 1 has reduced scale and opacity', () {
      final t = StackLayout.compute(
        index: 1,
        totalVisible: 3,
        expanded: false,
        toastHeight: 60,
        gap: 8,
        expandedGap: 12,
        position: ToastPosition.topRight,
      );
      expect(t.scale, 0.95);
      expect(t.opacity, 0.85);
      expect(t.offset.dy, 8.0);
    });

    test('collapsed: index 3+ has zero opacity', () {
      final t = StackLayout.compute(
        index: 3,
        totalVisible: 4,
        expanded: false,
        toastHeight: 60,
        gap: 8,
        expandedGap: 12,
        position: ToastPosition.topRight,
      );
      expect(t.opacity, 0.0);
    });

    test('expanded: full gap between toasts', () {
      final t0 = StackLayout.compute(
        index: 0,
        totalVisible: 3,
        expanded: true,
        toastHeight: 60,
        gap: 8,
        expandedGap: 12,
        position: ToastPosition.topRight,
      );
      final t1 = StackLayout.compute(
        index: 1,
        totalVisible: 3,
        expanded: true,
        toastHeight: 60,
        gap: 8,
        expandedGap: 12,
        position: ToastPosition.topRight,
      );
      expect(t0.offset.dy, 0.0);
      expect(t1.offset.dy, 72.0);
      expect(t1.scale, 1.0);
      expect(t1.opacity, 1.0);
    });

    test('top positions stack downward (positive y)', () {
      final t = StackLayout.compute(
        index: 1,
        totalVisible: 2,
        expanded: false,
        toastHeight: 60,
        gap: 8,
        expandedGap: 12,
        position: ToastPosition.topCenter,
      );
      expect(t.offset.dy, greaterThan(0));
    });

    test('bottom positions stack upward (negative y)', () {
      final t = StackLayout.compute(
        index: 1,
        totalVisible: 2,
        expanded: false,
        toastHeight: 60,
        gap: 8,
        expandedGap: 12,
        position: ToastPosition.bottomCenter,
      );
      expect(t.offset.dy, lessThan(0));
    });
  });
}
