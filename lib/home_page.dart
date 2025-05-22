import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _toggleOverlay() async {
    final isGranted = await FlutterOverlayWindow.isPermissionGranted();
    if (!isGranted) {
      await FlutterOverlayWindow.requestPermission();
    }

    if (await FlutterOverlayWindow.isActive()) {
      await FlutterOverlayWindow.closeOverlay();
    } else {
      await FlutterOverlayWindow.showOverlay(
        height: 1600,
        width: 1200,
        enableDrag: false,
        flag: OverlayFlag.defaultFlag,
        alignment: OverlayAlignment.center,
        overlayContent: "overlayMain",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleOverlay,
          child: const Text('Toggle Overlay'),
        ),
      ),
    );
  }
}
