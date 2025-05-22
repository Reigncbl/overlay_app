import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'home_page.dart';
import 'overlay_widget.dart';
import 'overlay_state.dart';

Future<void> showOverlayForState(OverlayViewState state) async {
  if (await FlutterOverlayWindow.isActive()) {
    await FlutterOverlayWindow.closeOverlay();
    await Future.delayed(const Duration(milliseconds: 250));
  }
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
}

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
        await showOverlayForState(
          OverlayViewState.full,
        ); // always start full mode
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
  runApp(
    OverlayWidget(
      onModeChange: (mode) async {
        await showOverlayForState(
          mode,
        ); // This closes & opens overlay with the correct size!
        OverlayStateController.overlayStateNotifier.value = mode;
      },
    ),
  );
}
