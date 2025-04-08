import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';

class ActionLine extends StatelessWidget {
  final String title, icon;
  final String? trailing;
  final Function()? onTap;
  const ActionLine({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: padding * 2 / 5),
        child: Row(
          children: [
            IconifyIcon(icon: icon, color: theme.primaryColorDark, size: 25),
            SizedBox(width: 10),
            Text(
              title,
              style: theme.textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(),
            if (trailing != null)
              Text(trailing!, style: theme.textTheme.titleMedium),
            SizedBox(width: 10),
            Icon(Icons.chevron_right_outlined, color: theme.primaryColorDark),
          ],
        ),
      ),
    );
  }
}
