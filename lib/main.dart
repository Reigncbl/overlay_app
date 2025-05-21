import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'home_page.dart';
import 'overlay_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel("overlay_channel").setMethodCallHandler((call) async {
    debugPrint("Received method call from native: ${call.method}");
    if (call.method == "showOverlay") {
      final isGranted = await FlutterOverlayWindow.isPermissionGranted();
      if (!isGranted) {
        await FlutterOverlayWindow.requestPermission();
      }

      if (!await FlutterOverlayWindow.isActive()) {
        await FlutterOverlayWindow.showOverlay(
          height: 1000,
          width: 1000,
          enableDrag: true,
          flag: OverlayFlag.defaultFlag,
          alignment: OverlayAlignment.center,
          overlayContent: "overlayMain",
        );
      }
    }
  });

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
