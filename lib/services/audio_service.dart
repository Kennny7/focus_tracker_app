import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final SharedPreferences _prefs;
  static const String _customSoundPathKey = 'custom_sound_path';

  AudioService(this._prefs);

  Future<void> playPunishmentSound() async {
    String? soundPath = _prefs.getString(_customSoundPathKey);
    if (soundPath != null && File(soundPath).existsSync()) {
      await _player.play(DeviceFileSource(soundPath));
    } else {
      await _player.play(AssetSource('sounds/punishment.mp3'));
    }
  }

  Future<void> pickCustomSound() async {
    // Use static methods (works with file_picker 4.x and above)
    String? directory = await FilePicker.getDirectoryPath();
    if (directory == null) return;

    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.audio,
      allowedExtensions: ['mp3', 'wav'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final destFile = File('${appDir.path}/custom_punishment.mp3');
      await file.copy(destFile.path);
      await _prefs.setString(_customSoundPathKey, destFile.path);
    }
  }

  void dispose() {
    _player.dispose();
  }
}