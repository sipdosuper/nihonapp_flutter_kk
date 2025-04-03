import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String settingTitle;
  final String settingDesc;
  final VoidCallback onTap;
  const SettingsTile({
    super.key,
    required this.icon,
    required this.settingTitle,
    required this.onTap,
    this.settingDesc = "",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.outline,
        ),
        child: ListTile(
          leading: Icon(icon),
          title: settingDesc != ""
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(settingTitle),
                    Text(
                      settingDesc,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                )
              : Text(settingTitle),
        ),
      ),
    );
  }
}
