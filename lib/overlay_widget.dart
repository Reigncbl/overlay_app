import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'overlay_state.dart'; // make sure this points to the updated file

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  @override
  void initState() {
    super.initState();
    OverlayStateController.overlayStateNotifier.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    OverlayStateController.overlayStateNotifier.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  void _toggleOverlayState() async {
    if (OverlayStateController.currentView == OverlayViewState.full) {
      OverlayStateController.switchToBubble();
      await FlutterOverlayWindow.showOverlay(
        height: 150,
        width: 150,
        alignment: OverlayAlignment.bottomRight,
        enableDrag: false,
        overlayContent: "overlayMain",
        flag: OverlayFlag.defaultFlag,
      );
    } else {
      OverlayStateController.switchToFull();
      await FlutterOverlayWindow.showOverlay(
        height: 1600,
        width: 1200,
        alignment: OverlayAlignment.center,
        enableDrag: false,
        overlayContent: "overlayMain",
        flag: OverlayFlag.defaultFlag,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFull = OverlayStateController.currentView == OverlayViewState.full;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        child: isFull ? _buildFullOverlay() : _buildBubble(),
      ),
    );
  }

  Widget _buildFullOverlay() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(minWidth: 800, minHeight: 1200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Latest Telegram Message',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Loading latest message...',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, right: 16),
        child: GestureDetector(
          onTap: _toggleOverlayState,
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: const Icon(Icons.chat_bubble, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }
}
