import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {
  final String name;
  final String description;
  final bool unlocked;

  const AchievementBadge({
    super.key,
    required this.name,
    required this.description,
    this.unlocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: unlocked ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: unlocked ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            unlocked ? Icons.emoji_events : Icons.lock_outline,
            size: 18,
            color: unlocked ? Colors.amber : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              color: unlocked ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}