import 'package:flutter/material.dart';

//for the settings textwords
class SettingsListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsListItem({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
