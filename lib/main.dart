import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'home_page.dart';
import 'overlay_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request overlay permission
  final isGranted = await FlutterOverlayWindow.isPermissionGranted();
  if (!isGranted) {
    await FlutterOverlayWindow.requestPermission();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

@pragma("vm:entry-point")
void overlayMain() {
  runApp(const OverlayWidget());
}
