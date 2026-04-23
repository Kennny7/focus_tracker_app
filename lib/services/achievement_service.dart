import 'package:shared_preferences/shared_preferences.dart';
import 'stats_service.dart';
import '../utils/constants.dart';  // ✅ Import AppConstants

class AchievementService {
  final SharedPreferences _prefs;
  final StatsService _statsService;
  static const String _streakKey = 'current_streak';
  static const String _bestStreakKey = 'best_streak';
  static const String _unlockedAchievementsKey = 'unlocked_achievements';

  AchievementService(this._prefs, this._statsService);

  // ✅ Use achievements from AppConstants instead of local list
  List<Map<String, dynamic>> get achievements => AppConstants.achievements;

  Future<int> getCurrentStreak() async {
    return _prefs.getInt(_streakKey) ?? 0;
  }

  Future<int> getBestStreak() async {
    return _prefs.getInt(_bestStreakKey) ?? 0;
  }

  /// Call this AFTER adding the completed session to [StatsService].
  /// Returns list of newly unlocked achievement IDs (empty if none).
  Future<List<String>> recordSessionCompletion(bool wasPunished) async {
    int streak = await getCurrentStreak();
    if (!wasPunished) {
      streak++;
      if (streak > await getBestStreak()) {
        await _prefs.setInt(_bestStreakKey, streak);
      }
    } else {
      streak = 0;
    }
    await _prefs.setInt(_streakKey, streak);

    final sessions = await _statsService.getSessions();
    final totalSessions = sessions.length;
    final unlocked = await _getUnlockedAchievementIds();

    List<String> newAchievements = [];
    for (var ach in achievements) {
      if (!unlocked.contains(ach['id'])) {
        bool achieved = false;
        switch (ach['id']) {
          case 'first_focus': achieved = totalSessions >= 1; break;
          case 'streak_3': achieved = streak >= 3; break;
          case 'streak_5': achieved = streak >= 5; break;
          case 'streak_10': achieved = streak >= 10; break;
          case 'total_10': achieved = totalSessions >= 10; break;
          case 'total_50': achieved = totalSessions >= 50; break;
        }
        if (achieved) newAchievements.add(ach['id']);
      }
    }

    if (newAchievements.isNotEmpty) {
      final updatedUnlocked = [...unlocked, ...newAchievements];
      await _prefs.setStringList(_unlockedAchievementsKey, updatedUnlocked);
    }

    return newAchievements;
  }

  Future<List<String>> _getUnlockedAchievementIds() async {
    return _prefs.getStringList(_unlockedAchievementsKey) ?? [];
  }

  Future<List<Map<String, dynamic>>> getUnlockedAchievements() async {
    final unlockedIds = await _getUnlockedAchievementIds();
    return achievements.where((a) => unlockedIds.contains(a['id'])).toList();
  }

  /// Returns all achievements with an extra 'unlocked' boolean.
  Future<List<Map<String, dynamic>>> getAllAchievementsWithStatus() async {
    final unlockedIds = await _getUnlockedAchievementIds();
    return achievements.map((ach) {
      return {
        ...ach,
        'unlocked': unlockedIds.contains(ach['id']),
      };
    }).toList();
  }

  Future<bool> isAchievementUnlocked(String id) async {
    final unlocked = await _getUnlockedAchievementIds();
    return unlocked.contains(id);
  }
}