import 'dart:async';

import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';
import 'package:flutter_sonner_smooth/src/toast_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(ToastService.instance.reset);

  group('toast.promise', () {
    test('resolves to success', () async {
      final completer = Completer<String>();
      final id = toast.promise<String>(
        completer.future,
        loading: 'Loading...',
        success: (v) => 'Got $v',
        error: (e) => 'Failed: $e',
      );

      expect(ToastService.instance.findById(id)?.type, ToastType.loading);

      completer.complete('data');
      await Future<void>.delayed(Duration.zero);

      final entry = ToastService.instance.findById(id);
      expect(entry?.type, ToastType.success);
      expect(entry?.message, 'Got data');
    });

    test('rejects to error', () async {
      final completer = Completer<String>();
      final id = toast.promise<String>(
        completer.future,
        loading: 'Loading...',
        success: (v) => 'Got $v',
        error: (e) => 'Failed: $e',
      );

      completer.completeError('oops');
      await Future<void>.delayed(Duration.zero);

      final entry = ToastService.instance.findById(id);
      expect(entry?.type, ToastType.error);
      expect(entry?.message, 'Failed: oops');
    });

    test('early dismiss prevents transition', () async {
      final completer = Completer<String>();
      final id = toast.promise<String>(
        completer.future,
        loading: 'Loading...',
        success: (v) => 'Got $v',
        error: (e) => 'Failed: $e',
      );

      toast.dismiss(id);
      expect(ToastService.instance.findById(id), isNull);

      completer.complete('data');
      await Future<void>.delayed(Duration.zero);

      expect(ToastService.instance.findById(id), isNull);
    });
  });
}
