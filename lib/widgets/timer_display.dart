import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final int seconds;
  final bool isGracePeriodActive;

  const TimerDisplay({
    super.key,
    required this.seconds,
    this.isGracePeriodActive = false,
  });

  String _formatTime(int seconds) {
    final mins = seconds ~/ 60;
    final secs = seconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _formatTime(seconds),
          style: const TextStyle(
            fontSize: 90,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            color: Colors.white,
          ),
        ),
        if (isGracePeriodActive)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "⚠️ Grace period – stay focused!",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}