class FocusSession {
  final DateTime timestamp;
  final int durationSeconds;      // total focus time in this session
  final bool wasPunished;         // did punishment occur?
  final String? punishmentType;   // 'sound', 'wallpaper', etc.

  FocusSession({
    required this.timestamp,
    required this.durationSeconds,
    required this.wasPunished,
    this.punishmentType,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'durationSeconds': durationSeconds,
    'wasPunished': wasPunished,
    'punishmentType': punishmentType,
  };

  factory FocusSession.fromJson(Map<String, dynamic> json) => FocusSession(
    timestamp: DateTime.parse(json['timestamp']),
    durationSeconds: json['durationSeconds'],
    wasPunished: json['wasPunished'],
    punishmentType: json['punishmentType'],
  );
}