import 'package:flutter_overlay_window/flutter_overlay_window.dart';
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
