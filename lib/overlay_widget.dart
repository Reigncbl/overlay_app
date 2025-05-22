import 'package:flutter/material.dart';
import 'overlay_state.dart';

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

  void _toggleOverlayState() {
    if (OverlayStateController.currentView == OverlayViewState.full) {
      OverlayStateController.switchToBubble();
    } else {
      OverlayStateController.switchToFull();
    }
    // Do NOT call FlutterOverlayWindow.showOverlay here!
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
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 350,
            maxWidth: 400,
            minHeight: 540,
            maxHeight: 550,
          ),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Chat Analysis",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Make text visible on blue
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _toggleOverlayState,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,

                        shape: const CircleBorder(),
                      ),
                      // icon: const Icon(Icons.close),
                      label: const Text('X'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 0,
                    bottom: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6ED),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Message section
                      Text(
                        "Message from Carlo:",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        margin: const EdgeInsets.only(bottom: 16, top: 2),
                        child: Text(
                          "Let's just skip the technical details and move on, hahahahaha!",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      // Tabs (non-interactive for this static version)
                      Row(
                        children: [
                          _AnalysisTab(
                            text: "Emotion Analysis",
                            selected: true,
                          ),
                          _AnalysisTab(text: "Response\nSuggestion"),
                          _AnalysisTab(text: "Tone Adjuster"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Emotion tags
                      Wrap(
                        spacing: 8,
                        children: const [
                          _EmotionTag(text: "joy (9/10)"),
                          _EmotionTag(text: "surprise (7/10)"),
                          _EmotionTag(text: "acceptance (6/10)"),
                          _EmotionTag(text: "anticipation (5/10)"),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Analysis Cards
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: const [
                              _EmotionAnalysisCard(
                                emotion: "Joy",
                                percent: 90,
                                description:
                                    "The laughter and use of 'HAHAHAHAHA' clearly indicates a feeling of joy and amusement at the prospect of not having to face technical questions.",
                                highlighted: true,
                              ),
                              _EmotionAnalysisCard(
                                emotion: "Surprise",
                                percent: 70,
                                description:
                                    "The statement is unexpected, a sudden shift from potentially serious matters to a humorous dismissal. This creates a sense of surprise.",
                              ),
                              _EmotionAnalysisCard(
                                emotion: "Acceptance",
                                percent: 60,
                                description:
                                    "There's a subtle element of playful avoidance, suggesting a mild acceptance of the situation - agreeing to not be challenged with technicalities.",
                              ),
                              _EmotionAnalysisCard(
                                emotion: "Anticipation",
                                percent: 50,
                                description:
                                    "The statement is unexpected, a sudden shift from potentially serious matters to a humorous dismissal. This creates a sense of surprise.",
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Footer
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          "Powered by EmotiCoach",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

class _AnalysisTab extends StatelessWidget {
  final String text;
  final bool selected;
  const _AnalysisTab({required this.text, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: selected ? Colors.blue : Colors.black54,
          fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          fontSize: 15,
          decoration: selected ? TextDecoration.underline : null,
          decorationThickness: 2,
        ),
      ),
    );
  }
}

class _EmotionTag extends StatelessWidget {
  final String text;
  const _EmotionTag({required this.text});
  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Colors.blue),
      ),
      backgroundColor: Colors.blue.shade50,
      shape: const StadiumBorder(),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }
}

class _EmotionAnalysisCard extends StatelessWidget {
  final String emotion;
  final int percent;
  final String description;
  final bool highlighted;
  const _EmotionAnalysisCard({
    required this.emotion,
    required this.percent,
    required this.description,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: highlighted ? Colors.purple : Colors.grey.shade300,
            width: 3,
          ),
        ),
        color: highlighted ? Colors.purple.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emotion,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: highlighted ? Colors.purple : Colors.black87,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                "$percent%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: highlighted ? Colors.purple : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(fontSize: 14)),
          ],
        ],
      ),
    );
  }
}
