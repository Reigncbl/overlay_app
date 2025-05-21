import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  String _latestMessage = 'Loading latest message...';

  @override
  void initState() {
    super.initState();
    _fetchLatestMessage();
  }

  Future<void> _fetchLatestMessage() async {
    try {
      final url = Uri.parse('http://10.0.2.2:8000/messages');
      final Map<String, dynamic> requestBody = {
        "phone": "9615365763", // Replace with the target phone without +63
        "first_name": "Carlo", // Optional
        "last_name": "Lorieta", // Optional
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey("messages") &&
            (data["messages"] as List).isNotEmpty) {
          final firstMsg = data["messages"][0];
          setState(
            () =>
                _latestMessage =
                    'From ${firstMsg["from"]}: ${firstMsg["text"]}',
          );
        } else if (data.containsKey("error")) {
          setState(() => _latestMessage = 'Error: ${data["error"]}');
        } else {
          setState(() => _latestMessage = 'No messages found.');
        }
      } else {
        setState(
          () =>
              _latestMessage =
                  'Failed to fetch message. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      setState(() => _latestMessage = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 800,
              maxWidth: 1200,
              minHeight: 1000,
              maxHeight: 1200,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Latest Telegram Message',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _latestMessage,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
