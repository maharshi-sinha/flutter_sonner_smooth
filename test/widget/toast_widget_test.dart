import 'package:flutter/widgets.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';
import 'package:flutter_sonner_smooth/src/toast_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ToastTheme(
        data: ToastThemeData.light(),
        child: Center(child: child),
      ),
    );
  }

  group('ToastWidget', () {
    testWidgets('renders message', (tester) async {
      await tester.pumpWidget(
        wrap(
          ToastWidget(
            entry: ToastEntry(
              id: '1',
              message: 'Hello world',
              type: ToastType.neutral,
              duration: const Duration(seconds: 4),
              position: ToastPosition.topRight,
              createdAt: DateTime.now(),
            ),
            progress: 1.0,
          ),
        ),
      );
      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets('renders description', (tester) async {
      await tester.pumpWidget(
        wrap(
          ToastWidget(
            entry: ToastEntry(
              id: '1',
              message: 'Title',
              description: 'Subtitle text',
              type: ToastType.success,
              duration: const Duration(seconds: 4),
              position: ToastPosition.topRight,
              createdAt: DateTime.now(),
            ),
            progress: 0.5,
          ),
        ),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle text'), findsOneWidget);
    });

    testWidgets('renders without progress bar for loading', (tester) async {
      await tester.pumpWidget(
        wrap(
          ToastWidget(
            entry: ToastEntry(
              id: '1',
              message: 'Loading...',
              type: ToastType.loading,
              duration: Duration.zero,
              position: ToastPosition.topRight,
              createdAt: DateTime.now(),
            ),
            progress: null,
          ),
        ),
      );
      expect(find.text('Loading...'), findsOneWidget);
    });
  });
}
