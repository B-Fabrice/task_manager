import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/modal_layout.dart';
import 'package:task_manager/widgets/app_button.dart';

Future<dynamic> showLogoutModal(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierLabel: '',
    barrierDismissible: true,
    pageBuilder: (context, animate, secondAnimate) {
      return LogoutModal();
    },
  );
}

class LogoutModal extends StatelessWidget {
  const LogoutModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModalLayout(
      child: Column(
        children: [
          Text('Confirm Logout', style: theme.textTheme.titleMedium),
          SizedBox(height: padding),
          Text(
            'Are you sure you want to logout?',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: padding),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: 'Cancel',
                  onTap: () => Navigator.pop(context),
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: padding),
              Expanded(
                child: AppButton(
                  text: 'Yes',
                  onTap: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
