import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/theme/colors.dart';

final messengerKey = GlobalKey<ScaffoldMessengerState>();

enum MessageType { success, error }

void showSnackbar(String message, MessageType type) {
  final context = messengerKey.currentContext;
  if (context != null) {
    final theme = Theme.of(context).textTheme;
    late Color color;
    late Color backgroundColor;
    late String icon;

    switch (type) {
      case MessageType.success:
        color = white;
        backgroundColor = primary;
        icon = 'weui:done2-outlined';
        break;
      case MessageType.error:
        color = white;
        backgroundColor = red;
        icon = 'nonicons:error-16';
        break;
    }
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        backgroundColor: backgroundColor,
        dismissDirection: DismissDirection.down,
        showCloseIcon: true,
        closeIconColor: color,
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconifyIcon(icon: icon, color: color, size: 30),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.bodyMedium!.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
