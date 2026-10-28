import 'package:flutter/material.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';
import 'package:flutter_sonner_smooth/src/toast_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(ToastService.instance.reset);

  Widget buildApp() {
    return MaterialApp(
      builder: (context, child) => ToastLayer(child: child!),
      home: const Scaffold(body: Center(child: Text('Home'))),
    );
  }

  group('ToastLayer', () {
    testWidgets('mounts without error', (tester) async {
      await tester.pumpWidget(buildApp());
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('calling toast() adds a visible toast', (tester) async {
      await tester.pumpWidget(buildApp());
      toast('Test message');
      await tester.pump();
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('dismissAll clears toasts', (tester) async {
      await tester.pumpWidget(buildApp());
      toast('A');
      toast('B');
      await tester.pump();
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);

      toast.dismissAll();
      await tester.pump();
      expect(find.text('A'), findsNothing);
      expect(find.text('B'), findsNothing);
    });
  });
}
