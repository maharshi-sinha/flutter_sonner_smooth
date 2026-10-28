import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026);

  ToastEntry makeEntry({
    String id = 'test_1',
    String message = 'Hello',
    String? description,
    ToastType type = ToastType.neutral,
  }) {
    return ToastEntry(
      id: id,
      message: message,
      description: description,
      type: type,
      duration: const Duration(seconds: 4),
      position: ToastPosition.topRight,
      createdAt: now,
    );
  }

  group('ToastEntry', () {
    test('copyWith preserves unchanged fields', () {
      final entry = makeEntry(description: 'desc');
      final copy = entry.copyWith(message: 'Updated');
      expect(copy.id, entry.id);
      expect(copy.message, 'Updated');
      expect(copy.description, 'desc');
      expect(copy.type, entry.type);
      expect(copy.duration, entry.duration);
      expect(copy.position, entry.position);
      expect(copy.createdAt, entry.createdAt);
    });

    test('copyWith replaces specified fields', () {
      final entry = makeEntry();
      final copy = entry.copyWith(
        type: ToastType.success,
        description: 'new desc',
      );
      expect(copy.type, ToastType.success);
      expect(copy.description, 'new desc');
      expect(copy.message, entry.message);
    });

    test('equality works correctly', () {
      final a = makeEntry();
      final b = makeEntry();
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when fields differ', () {
      final a = makeEntry(id: 'a');
      final b = makeEntry(id: 'b');
      expect(a, isNot(equals(b)));
    });

    test('toString includes key fields', () {
      final entry = makeEntry();
      expect(entry.toString(), contains('test_1'));
      expect(entry.toString(), contains('Hello'));
    });
  });
}
