import 'package:flutter/material.dart';

class AppConstants {
  // Insults list (20 hardcoded)
  static const List<String> insults = [
    "You weak-willed fool! 🤡",
    "Lost focus again? Pathetic.",
    "Even a goldfish has better attention span.",
    "Discipline? Never heard of her.",
    "Congrats, you played yourself.",
    "Sloth called, wants its crown back.",
    "Focus? Never met her.",
    "Your ancestors are ashamed.",
    "Did the notification glow distract you?",
    "Maybe try blinking less?",
    "Productivity -1000.",
    "You just lost The Game.",
    "I'm not angry, just disappointed.",
    "Back to zero, loser.",
    "That click cost you dignity.",
    "You are the reason dial-up died.",
    "Try harder or just give up?",
    "Watching paint dry would be more productive.",
    "Moss grows faster than your focus.",
    "Oof, right in the self-control.",
  ];

  // Achievement definitions
  static const List<Map<String, dynamic>> achievements = [
    {'id': 'first_focus', 'name': 'First Step', 'description': 'Complete your first focus session', 'requirement': 1, 'type': 'total'},
    {'id': 'streak_3', 'name': 'Getting Serious', 'description': '3 sessions without punishment', 'requirement': 3, 'type': 'streak'},
    {'id': 'streak_5', 'name': 'Focus Master', 'description': '5 sessions without punishment', 'requirement': 5, 'type': 'streak'},
    {'id': 'streak_10', 'name': 'Unbreakable', 'description': '10 sessions without punishment', 'requirement': 10, 'type': 'streak'},
    {'id': 'total_10', 'name': 'Dedicated', 'description': 'Complete 10 total sessions', 'requirement': 10, 'type': 'total'},
    {'id': 'total_50', 'name': 'Focus Warrior', 'description': 'Complete 50 total sessions', 'requirement': 50, 'type': 'total'},
  ];

  // Default timer values
  static const int defaultFocusMinutes = 25;
  static const int defaultShortBreakMinutes = 5;
  static const int defaultLongBreakMinutes = 15;
  static const int defaultCyclesBeforeLongBreak = 4;
}