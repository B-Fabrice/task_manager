import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/modals/logout_modal.dart';
import 'package:task_manager/modals/mode_modal.dart';
import 'package:task_manager/screens/auth/login.dart';
import 'package:task_manager/shared_states.dart';
import 'package:task_manager/theme/colors.dart';
import 'package:task_manager/widgets/action_line.dart';
import 'package:task_manager/widgets/profile_image.dart';

class Account extends ConsumerWidget {
  const Account({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final textTheme = Theme.of(context).textTheme;
    String mode = 'system';
    if (theme?.brightness == Brightness.light) {
      mode = 'light';
    } else if (theme?.brightness == Brightness.dark) {
      mode = 'dark';
    }
    return ListView(
      padding: EdgeInsets.all(padding),
      children: [
        Column(
          children: [
            ProfileImage(size: 120),
            const SizedBox(height: padding),
            Text(user?.displayName ?? '', style: textTheme.labelMedium),
            Text(user?.email ?? '', style: textTheme.titleMedium),
          ],
        ),
        const SizedBox(height: padding * 4),
        ActionLine(title: 'Edit Profile', icon: 'lucide:user'),
        SizedBox(height: padding),
        ActionLine(title: 'Privacy Policy', icon: 'lucide:shield-check'),
        SizedBox(height: padding),
        ActionLine(title: 'Language', icon: 'lucide:languages'),
        SizedBox(height: padding),
        ActionLine(title: 'Support', icon: 'lucide:circle-help'),
        SizedBox(height: padding),
        ActionLine(
          title: 'Mode',
          icon: 'lucide:sun-moon',
          trailing: mode,
          onTap: () => showModeModal(context),
        ),
        SizedBox(height: padding * 4),
        GestureDetector(
          onTap: () async {
            final response = await showLogoutModal(context);
            if (response == true) {
              final auth = FirebaseAuth.instance;
              auth.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.logout_outlined, color: red, size: 20),
              SizedBox(width: padding),
              Text(
                'Logout',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
