import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/focus_session.dart';

class StatsService {
  static const String _sessionsKey = 'focus_sessions';
  final SharedPreferences _prefs;

  StatsService(this._prefs);

  // Save a new session
  Future<void> addSession(FocusSession session) async {
    final sessions = await getSessions();
    sessions.add(session);
    final jsonList = sessions.map((s) => s.toJson()).toList();
    await _prefs.setString(_sessionsKey, jsonEncode(jsonList));
  }

  // Get all sessions
  Future<List<FocusSession>> getSessions() async {
    final jsonString = _prefs.getString(_sessionsKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((j) => FocusSession.fromJson(j)).toList();
  }

  // Clear all sessions (for testing)
  Future<void> clearSessions() async {
    await _prefs.remove(_sessionsKey);
  }

  // Statistics for dashboard
  Future<Map<String, dynamic>> getStats() async {
    final sessions = await getSessions();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    int totalFocusSeconds = 0;
    int totalPunishments = 0;
    int todayFocusSeconds = 0;
    int todayPunishments = 0;
    int weekFocusSeconds = 0;
    int weekPunishments = 0;

    for (var s in sessions) {
      totalFocusSeconds += s.durationSeconds;
      if (s.wasPunished) totalPunishments++;

      if (s.timestamp.isAfter(todayStart)) {
        todayFocusSeconds += s.durationSeconds;
        if (s.wasPunished) todayPunishments++;
      }
      if (s.timestamp.isAfter(weekStart)) {
        weekFocusSeconds += s.durationSeconds;
        if (s.wasPunished) weekPunishments++;
      }
    }

    return {
      'totalFocusMinutes': (totalFocusSeconds / 60).round(),
      'totalPunishments': totalPunishments,
      'todayFocusMinutes': (todayFocusSeconds / 60).round(),
      'todayPunishments': todayPunishments,
      'weekFocusMinutes': (weekFocusSeconds / 60).round(),
      'weekPunishments': weekPunishments,
      'totalSessions': sessions.length,
    };
  }
}