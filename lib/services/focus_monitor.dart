import 'dart:async';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

typedef PunishmentCallback = void Function();

class FocusMonitor with WindowListener {
  bool _isFocused = true;  // ⚠️ Not used anywhere (can be removed)
  bool _gracePeriodActive = false;
  Timer? _graceTimer;
  final PunishmentCallback onPunishmentTrigger;
  final ValueNotifier<bool> isGracePeriodActiveNotifier = ValueNotifier(false);

  FocusMonitor({required this.onPunishmentTrigger});

  void startMonitoring() {
    windowManager.addListener(this);
  }

  void dispose() {
    windowManager.removeListener(this);
    _graceTimer?.cancel();
    isGracePeriodActiveNotifier.dispose();
  }

  @override
  void onWindowFocusChanged(bool isFocused) {
    _handleFocusChange(!isFocused); // true = lost focus
  }

  @override
  void onWindowMinimize() {
    _handleFocusChange(true); // minimize counts as lost focus
  }

  void _handleFocusChange(bool lostFocus) {
    if (lostFocus && !_gracePeriodActive) {
      _gracePeriodActive = true;
      isGracePeriodActiveNotifier.value = true;
      _graceTimer = Timer(const Duration(seconds: 3), () {
        if (_gracePeriodActive) {
          onPunishmentTrigger();
          _resetGrace();
        }
      });
    } else if (!lostFocus && _gracePeriodActive) {
      _resetGrace();
    }
  }

  void _resetGrace() {
    _graceTimer?.cancel();
    _gracePeriodActive = false;
    isGracePeriodActiveNotifier.value = false;
  }
}