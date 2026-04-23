import 'package:flutter/material.dart';
import '../services/timer_service.dart';

class DurationSelector extends StatelessWidget {
  final TimerService timerService;

  const DurationSelector({super.key, required this.timerService});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Pomodoro Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDurationControl(
                  label: 'Focus',
                  value: timerService.focusMinutes,
                  onChanged: (v) => timerService.setFocusMinutes(v),
                  enabled: !timerService.isRunning,
                ),
                _buildDurationControl(
                  label: 'Short Break',
                  value: timerService.shortBreakMinutes,
                  onChanged: (v) => timerService.setShortBreakMinutes(v), 
                  enabled: !timerService.isRunning,
                ),
                _buildDurationControl(
                  label: 'Long Break',
                  value: timerService.longBreakMinutes,
                  onChanged: (v) => timerService.setLongBreakMinutes(v), 
                  enabled: !timerService.isRunning,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationControl({
    required String label,
    required int value,
    required Function(int) onChanged,
    required bool enabled,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Row(
          children: [
            IconButton(
              onPressed: enabled && value > 1
                  ? () => onChanged(value - 1)
                  : null,
              icon: const Icon(Icons.remove_circle, size: 28),
            ),
            Text('$value min', style: const TextStyle(fontSize: 16)),
            IconButton(
              onPressed: enabled && value < 120
                  ? () => onChanged(value + 1)
                  : null,
              icon: const Icon(Icons.add_circle, size: 28),
            ),
          ],
        ),
      ],
    );
  }
}