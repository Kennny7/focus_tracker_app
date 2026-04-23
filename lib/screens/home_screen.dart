import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import '../services/timer_service.dart';
import '../services/focus_monitor.dart';
import '../services/punishment_service.dart';
import '../services/audio_service.dart';
import '../services/stats_service.dart';
import '../services/achievement_service.dart';
import '../widgets/timer_display.dart';
import '../widgets/control_buttons.dart';
import '../widgets/duration_selector.dart';
import '../widgets/settings_panel.dart';
import '../widgets/stats_dashboard.dart';
import '../utils/keyboard_shortcuts.dart';
import 'stats_screen.dart';
import '../models/focus_session.dart';

typedef DarkModeCallback = void Function(bool);

class HomeScreen extends StatefulWidget {
  final DarkModeCallback? onDarkModeChanged;
  const HomeScreen({super.key, this.onDarkModeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TimerService _timerService;
  late FocusMonitor _focusMonitor;
  late PunishmentService _punishmentService;
  late AudioService _audioService;
  late StatsService _statsService;
  late AchievementService _achievementService;
  late SharedPreferences _prefs;

  bool _strictMode = true;
  bool _darkMode = false;
  double _windowOpacity = 1.0;
  Map<String, dynamic> _stats = {};
  bool _isGracePeriodActive = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    _prefs = await SharedPreferences.getInstance();
    _audioService = AudioService(_prefs);
    _statsService = StatsService(_prefs);
    _achievementService = AchievementService(_prefs, _statsService);
    _punishmentService = PunishmentService(_audioService, _prefs);
    _timerService = TimerService();

    _strictMode = _prefs.getBool('strict_mode') ?? true;
    _darkMode = _prefs.getBool('dark_mode') ?? false;
    _windowOpacity = _prefs.getDouble('window_opacity') ?? 1.0;

    _timerService.onTick = (seconds) {
      if (mounted) setState(() {});
    };
    _timerService.onTimerComplete = _onTimerComplete;
    _timerService.onModeChanged = (mode) {
      if (mounted) setState(() {});
    };
    _timerService.onRunningChanged = (running) {
      if (mounted) setState(() {});
    };

    _focusMonitor = FocusMonitor(
      onPunishmentTrigger: () async {
        if (_timerService.isRunning && _timerService.currentSeconds > 0) {
          await _punishmentService.executePunishment(context, strictMode: _strictMode);
          if (_strictMode) {
            final elapsedFocusSeconds = (_timerService.focusMinutes * 60) - _timerService.currentSeconds;
            _timerService.forceResetToZero();
            await _recordSession(wasPunished: true, actualDurationSeconds: elapsedFocusSeconds);
          }
          if (mounted) setState(() {});
        }
      },
    );
    _focusMonitor.startMonitoring();
    _focusMonitor.isGracePeriodActiveNotifier.addListener(() {
      if (mounted) {
        setState(() {
          _isGracePeriodActive = _focusMonitor.isGracePeriodActiveNotifier.value;
        });
      }
    });

    await _refreshStats();
    if (mounted) setState(() {});
  }

  Future<void> _onTimerComplete() async {
    if (_timerService.mode == TimerMode.focus) {
      final fullDuration = _timerService.focusMinutes * 60;
      await _recordSession(wasPunished: false, actualDurationSeconds: fullDuration);
      await _achievementService.recordSessionCompletion(false);
      // TODO: Show achievement popup
    }
    await _refreshStats();
  }

  Future<void> _recordSession({required bool wasPunished, required int actualDurationSeconds}) async {
    final session = FocusSession(
      timestamp: DateTime.now(),
      durationSeconds: actualDurationSeconds,
      wasPunished: wasPunished,
    );
    await _statsService.addSession(session);
    await _refreshStats();
  }

  Future<void> _refreshStats() async {
    _stats = await _statsService.getStats();
    if (mounted) setState(() {});
  }

  void _toggleStrictMode(bool value) {
    setState(() => _strictMode = value);
    _prefs.setBool('strict_mode', value);
  }

  void _toggleDarkMode(bool value) {
    setState(() => _darkMode = value);
    _prefs.setBool('dark_mode', value);
    widget.onDarkModeChanged?.call(value);
  }

  void _changeOpacity(double value) async {
    setState(() => _windowOpacity = value);
    await windowManager.setOpacity(value);  // ✅ fixed: windowManager (not window_manager)
    _prefs.setDouble('window_opacity', value);
  }

  void _pickCustomSound() async {
    await _audioService.pickCustomSound();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Custom sound set!')),
      );
    }
  }

  void _navigateToStats() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const StatsScreen()),
    );
    await _refreshStats();
  }

  @override
  void dispose() {
    _timerService.dispose();
    _focusMonitor.dispose();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardShortcuts(
      onSpace: () {
        if (_timerService.isRunning) {
          _timerService.pause();
        } else {
          _timerService.start();
        }
        if (mounted) setState(() {});
      },
      onEscape: () {
        _timerService.reset();
        if (mounted) setState(() {});
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.deepPurple.shade900, Colors.black],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  TimerDisplay(
                    seconds: _timerService.currentSeconds,
                    isGracePeriodActive: _isGracePeriodActive,
                  ),
                  const SizedBox(height: 16),
                  ControlButtons(
                    onStart: () {
                      _timerService.start();
                      if (mounted) setState(() {});
                    },
                    onPause: () {
                      _timerService.pause();
                      if (mounted) setState(() {});
                    },
                    onReset: () {
                      _timerService.reset();
                      if (mounted) setState(() {});
                    },
                    isRunning: _timerService.isRunning,
                  ),
                  const SizedBox(height: 24),
                  DurationSelector(timerService: _timerService),
                  const SizedBox(height: 24),
                  SettingsPanel(
                    strictMode: _strictMode,
                    onStrictModeChanged: _toggleStrictMode,
                    darkMode: _darkMode,
                    onDarkModeChanged: _toggleDarkMode,
                    opacity: _windowOpacity,
                    onOpacityChanged: _changeOpacity,
                    onPickCustomSound: _pickCustomSound,
                  ),
                  const SizedBox(height: 24),
                  StatsDashboard(
                    stats: _stats,
                    onViewDetails: _navigateToStats,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}