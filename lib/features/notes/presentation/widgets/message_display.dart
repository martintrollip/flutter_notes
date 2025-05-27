import 'package:flutter/material.dart';

/// Displays a message with an icon.
class MessageDisplay extends StatelessWidget {
  const MessageDisplay({required this.icon, required this.message, super.key});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final iconColour = Theme.of(
      context,
    ).colorScheme.secondary.withValues(alpha: 0.7);
    final textColour = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.7);
    final textStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: textColour);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: iconColour),
            Text(message, style: textStyle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
