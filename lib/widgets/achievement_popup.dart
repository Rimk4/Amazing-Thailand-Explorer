import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementPopup extends StatelessWidget {
  final String achievementName;
  final VoidCallback onDismiss;

  const AchievementPopup({
    super.key,
    required this.achievementName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber),
          const SizedBox(width: 10),
          Text(AppLocalizations.of(context)!.achievementUnlocked),
        ],
      ),
      content: Text(achievementName),
      actions: [
        TextButton(
          onPressed: onDismiss,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
