import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'overlay_state.dart';

Future<void> showOverlayForState(OverlayViewState state) async {
  if (await FlutterOverlayWindow.isActive()) {
    await FlutterOverlayWindow.closeOverlay();
    await Future.delayed(const Duration(milliseconds: 250));
  }
  OverlayStateController.overlayStateNotifier.value = state; // <--- SET THIS!
  if (state == OverlayViewState.full) {
    await FlutterOverlayWindow.showOverlay(
      height: 1600,
      width: 1200,
      alignment: OverlayAlignment.center,
      overlayContent: "overlayMain",
    );
  } else {
    await FlutterOverlayWindow.showOverlay(
      height: 80,
      width: 80,
      alignment: OverlayAlignment.bottomRight,
      overlayContent: "overlayMain",
    );
  }
  OverlayStateController.overlayStateNotifier.value = state;
}

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
      await showOverlayForState(
        OverlayViewState.full,
      ); // Always start in full mode
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
