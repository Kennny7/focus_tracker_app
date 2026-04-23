import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class SettingsPanel extends StatefulWidget {
  final bool strictMode;
  final ValueChanged<bool> onStrictModeChanged;
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;
  final double opacity;
  final ValueChanged<double> onOpacityChanged;
  final VoidCallback onPickCustomSound;

  const SettingsPanel({
    super.key,
    required this.strictMode,
    required this.onStrictModeChanged,
    required this.darkMode,
    required this.onDarkModeChanged,
    required this.opacity,
    required this.onOpacityChanged,
    required this.onPickCustomSound,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Strict Mode (full punishment)'),
                Switch(
                  value: widget.strictMode,
                  onChanged: widget.onStrictModeChanged,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: widget.darkMode,
                  onChanged: widget.onDarkModeChanged,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Window Opacity: ${(widget.opacity * 100).toInt()}%'),
                Expanded(
                  child: Slider(
                    value: widget.opacity,
                    min: 0.5,
                    max: 1.0,
                    onChanged: widget.onOpacityChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: widget.onPickCustomSound,
              icon: const Icon(Icons.audiotrack),
              label: const Text('Pick Custom Punishment Sound'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}