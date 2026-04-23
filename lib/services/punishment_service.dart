import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'audio_service.dart';
import '../utils/constants.dart';  

class PunishmentService {
  final Random _random = Random();
  final AudioService _audioService;
  final SharedPreferences _prefs;
  static const String _wallpaperPunishmentEnabledKey = 'wallpaper_punishment';

  PunishmentService(this._audioService, this._prefs);

  Future<void> executePunishment(BuildContext context, {bool strictMode = true}) async {
    if (strictMode) {
      await _audioService.playPunishmentSound();
      await _showInsultDialog(context);
      if (_prefs.getBool(_wallpaperPunishmentEnabledKey) ?? false) {
        await _changeWallpaper();
      }
    } else {
      await _showInsultDialog(context);
    }
  }

  Future<void> _showInsultDialog(BuildContext context) async {
    final insults = AppConstants.insults;  // Use from constants.dart
    final insult = insults[_random.nextInt(insults.length)];

    // ✅ Ensure context is still valid before showing dialog
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: const Text('PUNISHMENT!'),
        content: Text(insult),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("I'll do better"),
          ),
        ],
      ),
    );
  }

  Future<void> _changeWallpaper() async {
    debugPrint("Wallpaper change would happen here");
  }

  void setWallpaperPunishmentEnabled(bool enabled) {
    _prefs.setBool(_wallpaperPunishmentEnabledKey, enabled);
  }

  bool isWallpaperPunishmentEnabled() {
    return _prefs.getBool(_wallpaperPunishmentEnabledKey) ?? false;
  }
}