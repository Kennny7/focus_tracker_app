import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // added for LogicalKeyboardKey

class KeyboardShortcuts extends StatelessWidget {
  final Widget child;
  final VoidCallback onSpace;   // Start/Pause toggle
  final VoidCallback onEscape;  // Reset timer

  const KeyboardShortcuts({
    super.key,
    required this.child,
    required this.onSpace,
    required this.onEscape,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.space): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const EscapeIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (intent) => onSpace(),
        ),
        EscapeIntent: CallbackAction<EscapeIntent>(
          onInvoke: (intent) => onEscape(),
        ),
      },
      child: child,
    );
  }
}

class ActivateIntent extends Intent {
  const ActivateIntent();
}

class EscapeIntent extends Intent {
  const EscapeIntent();
}