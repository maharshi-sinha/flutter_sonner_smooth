import 'package:flutter/material.dart';
import 'package:flutter_sonner_smooth/flutter_sonner_smooth.dart';

import 'pages/basic_demo.dart';
import 'pages/position_demo.dart';
import 'pages/promise_demo.dart';
import 'pages/stress_test.dart';
import 'pages/theme_demo.dart';

void main() {
  runApp(const SonnerExampleApp());
}

/// Example app showcasing flutter_sonner_smooth.
class SonnerExampleApp extends StatefulWidget {
  /// Creates the example app.
  const SonnerExampleApp({super.key});

  @override
  State<SonnerExampleApp> createState() => _SonnerExampleAppState();
}

class _SonnerExampleAppState extends State<SonnerExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sonner Smooth',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      builder: (context, child) => ToastLayer(child: child!),
      home: _Home(
        onToggleTheme: () {
          setState(() {
            _themeMode = _themeMode == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
          });
        },
      ),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int _index = 0;

  static const _pages = <Widget>[
    BasicDemo(),
    PromiseDemo(),
    PositionDemo(),
    ThemeDemo(),
    StressTest(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Sonner Smooth'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat_bubble), label: 'Basic'),
          NavigationDestination(icon: Icon(Icons.hourglass_top), label: 'Promise'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Position'),
          NavigationDestination(icon: Icon(Icons.palette), label: 'Theme'),
          NavigationDestination(icon: Icon(Icons.bolt), label: 'Stress'),
        ],
      ),
    );
  }
}
