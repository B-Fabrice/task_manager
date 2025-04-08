import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/screens/notifications.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/widgets/profile_image.dart';

class ProfileInfo extends ConsumerWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final stream = ref.watch(NotificationService.userNotificationStream);
    final notifications = stream.value ?? [];
    final isNotified =
        notifications.where((e) {
          return !e.isRead;
        }).isNotEmpty;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return PersonalInfo();
            //     },
            //   ),
            // );
          },
          child: Row(
            children: [
              ProfileImage(size: 60),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting(), style: textTheme.labelMedium),
                  Text(
                    user?.displayName ?? user?.email ?? '',
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Notifications();
                },
              ),
            );
            NotificationService.readNotifications(
              notifications.map((e) {
                return e.id;
              }).toList(),
            );
          },
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              IconifyIcon(
                icon: 'mingcute:notification-line',
                // color: black,
                size: 30,
              ),
              if (isNotified)
                Positioned(
                  child: IconifyIcon(
                    icon: 'icon-park-outline:dot',
                    // color: lightPrimary,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
