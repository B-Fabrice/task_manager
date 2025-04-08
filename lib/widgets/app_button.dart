import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/theme/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool disabled;
  final bool loading;
  final Color color;
  final Color background;
  final bool rounded;
  final Widget? prefix;
  final void Function()? onTap;
  const AppButton({
    required this.text,
    super.key,
    this.disabled = false,
    this.loading = false,
    this.color = white,
    this.background = secondary,
    this.rounded = false,
    this.prefix,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          AnimatedContainer(
            padding: EdgeInsets.all(padding),
            width: double.infinity,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: background.withValues(alpha: disabled ? 0.6 : 1),
              borderRadius: BorderRadius.circular(
                rounded ? roundRadius : borderRadius,
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(color: color),
            ),
          ),
          if (prefix != null) Positioned(left: 10, top: 10, child: prefix!),
        ],
      ),
    );
  }
}
