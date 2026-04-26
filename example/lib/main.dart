import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dev_overlay/dev_overlay.dart';

void main() {
  runApp(
    DevOverlay(
      enabled: kDebugMode, // automatically hides in release
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dev_overlay Example',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('dev_overlay')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👆 See the inspector panel in the top left'),
            const SizedBox(height: 8),
            const Text('Drag it anywhere on screen'),
            const SizedBox(height: 8),
            const Text('Tap it to collapse/expand'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  settings: const RouteSettings(name: '/second'),
                  builder: (_) => const SecondPage(),
                ),
              ),
              child: const Text('Go to Second Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: const Center(
        child: Text('Route shows /second in the inspector ✅'),
      ),
    );
  }
}
