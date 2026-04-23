import 'dart:async';

enum TimerMode { focus, shortBreak, longBreak }

class TimerService {
  int _currentSeconds = 25 * 60;
  TimerMode _mode = TimerMode.focus;
  Timer? _timer;
  bool _isRunning = false;

  // Callbacks
  Function(int seconds)? onTick;
  Function(TimerMode mode)? onModeChanged;
  Function(bool isRunning)? onRunningChanged;
  Function()? onTimerComplete;

  // Settings
  int focusMinutes = 25;
  int shortBreakMinutes = 5;
  int longBreakMinutes = 15;
  int cyclesBeforeLongBreak = 4;
  int _focusCycleCount = 0;

  int get currentSeconds => _currentSeconds;
  TimerMode get mode => _mode;
  bool get isRunning => _isRunning;

  void setFocusMinutes(int minutes) {
    if (!_isRunning && _mode == TimerMode.focus) {
      focusMinutes = minutes;
      _currentSeconds = minutes * 60;
      onTick?.call(_currentSeconds);
    }
  }

  void setShortBreakMinutes(int minutes) {
    if (!_isRunning && _mode == TimerMode.shortBreak) {
      shortBreakMinutes = minutes;
      _currentSeconds = minutes * 60;
      onTick?.call(_currentSeconds);
    }
  }

  void setLongBreakMinutes(int minutes) {
    if (!_isRunning && _mode == TimerMode.longBreak) {
      longBreakMinutes = minutes;
      _currentSeconds = minutes * 60;
      onTick?.call(_currentSeconds);
    }
  }

  void start() {
    if (_isRunning) return;
    if (_currentSeconds <= 0) {
      _resetToModeDuration();
    }
    _isRunning = true;
    onRunningChanged?.call(true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds <= 1) {
        _completeTimer();
      } else {
        _currentSeconds--;
        onTick?.call(_currentSeconds);
      }
    });
  }

  void pause() {
    if (!_isRunning) return;
    _isRunning = false;
    _timer?.cancel();
    onRunningChanged?.call(false);
  }

  void reset() {
    pause();
    _resetToModeDuration();
  }

  void forceResetToZero() {
    pause();
    _currentSeconds = 0;
    onTick?.call(0);
  }

  void switchMode(TimerMode newMode) {
    if (_isRunning) pause();
    _mode = newMode;
    _resetToModeDuration();
    onModeChanged?.call(_mode);
  }

  void _completeTimer() {
    pause();
    _currentSeconds = 0;
    onTick?.call(0);
    onTimerComplete?.call();

    if (_mode == TimerMode.focus) {
      _focusCycleCount++;
      if (_focusCycleCount >= cyclesBeforeLongBreak) {
        _switchMode(TimerMode.longBreak);
        _focusCycleCount = 0;
      } else {
        _switchMode(TimerMode.shortBreak);
      }
    } else {
      _switchMode(TimerMode.focus);
    }
  }

  void _switchMode(TimerMode newMode) {
    _mode = newMode;
    _resetToModeDuration();
    onModeChanged?.call(_mode);
  }

  void _resetToModeDuration() {
    switch (_mode) {
      case TimerMode.focus:
        _currentSeconds = focusMinutes * 60;
        break;
      case TimerMode.shortBreak:
        _currentSeconds = shortBreakMinutes * 60;
        break;
      case TimerMode.longBreak:
        _currentSeconds = longBreakMinutes * 60;
        break;
    }
    onTick?.call(_currentSeconds);
  }

  void dispose() {
    _timer?.cancel();
  }
}