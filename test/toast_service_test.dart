import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';
import 'package:flutter_sonner_smooth/src/toast_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ToastService service;

  setUp(() {
    service = ToastService.instance;
    service.reset();
  });

  ToastEntry makeEntry({
    String? id,
    ToastType type = ToastType.neutral,
    Duration duration = const Duration(seconds: 4),
  }) {
    return ToastEntry(
      id: id ?? generateToastId(),
      message: 'Test',
      type: type,
      duration: duration,
      position: ToastPosition.topRight,
      createdAt: DateTime.now(),
    );
  }

  group('ToastService', () {
    test('add returns id and appends entry', () {
      final entry = makeEntry(id: 'a');
      final id = service.add(entry);
      expect(id, 'a');
      expect(service.entries.length, 1);
      expect(service.entries.first.id, 'a');
    });

    test('add inserts newest first', () {
      service.add(makeEntry(id: 'first'));
      service.add(makeEntry(id: 'second'));
      expect(service.entries.first.id, 'second');
    });

    test('remove by id removes from list', () {
      service.add(makeEntry(id: 'x'));
      service.add(makeEntry(id: 'y'));
      service.remove('x');
      expect(service.entries.length, 1);
      expect(service.entries.first.id, 'y');
    });

    test('remove nonexistent id is safe', () {
      service.add(makeEntry(id: 'x'));
      service.remove('nonexistent');
      expect(service.entries.length, 1);
    });

    test('removeAll empties list', () {
      service.add(makeEntry(id: 'a'));
      service.add(makeEntry(id: 'b'));
      service.removeAll();
      expect(service.entries, isEmpty);
    });

    test('update mutates entry', () {
      service.add(makeEntry(id: 'u'));
      service.update('u', (e) => e.copyWith(message: 'Updated'));
      expect(service.entries.first.message, 'Updated');
    });

    test('findById returns entry or null', () {
      service.add(makeEntry(id: 'f'));
      expect(service.findById('f'), isNotNull);
      expect(service.findById('missing'), isNull);
    });

    test('loading toasts do not auto-dismiss', () async {
      service.add(
        makeEntry(
          id: 'loading',
          type: ToastType.loading,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(service.entries.length, 1);
    });

    test('onDismissed callback fires on remove', () {
      var called = false;
      final entry = ToastEntry(
        id: 'cb',
        message: 'Test',
        type: ToastType.neutral,
        duration: const Duration(seconds: 4),
        position: ToastPosition.topRight,
        createdAt: DateTime.now(),
        onDismissed: () => called = true,
      );
      service.add(entry);
      service.remove('cb');
      expect(called, isTrue);
    });

    test('generateToastId produces unique ids', () {
      final ids = <String>{};
      for (var i = 0; i < 100; i++) {
        ids.add(generateToastId());
      }
      expect(ids.length, 100);
    });
  });
}
