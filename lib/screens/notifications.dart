import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/theme/colors.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/widgets/app_button.dart';

class Notifications extends ConsumerWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stream = ref.watch(NotificationService.userNotificationStream);
    final color = Theme.of(context).primaryColorDark;
    final notifications = stream.value ?? [];
    notifications.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    final theme = Theme.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Notifications', style: theme.textTheme.titleMedium),
        ),
        body:
            notifications.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 180,
                        height: 180,
                        padding: EdgeInsets.all(padding),
                        decoration: BoxDecoration(
                          border: Border.all(width: 8, color: color),
                          borderRadius: BorderRadius.circular(180),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 100,
                          height: 100,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconifyIcon(
                              icon: 'mdi:bell-remove-outline',
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'There\'s no notifications',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        constraints: BoxConstraints(maxWidth: 270),
                        child: Text(
                          'Your notifications will be appear on this page',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : ListView(
                  padding: EdgeInsets.all(padding),
                  children:
                      notifications.map((e) {
                        return Container(
                          padding: EdgeInsets.all(padding),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(
                              alpha: e.isRead ? 0.1 : 0.4,
                            ),
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.title,
                                style: theme.textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  e.body,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  formatDateTime(e.createdAt),
                                  textAlign: TextAlign.end,
                                  style: theme.textTheme.bodyMedium!,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
        bottomNavigationBar:
            notifications.isNotEmpty
                ? Container(
                  height: 90,
                  alignment: Alignment.center,
                  padding: EdgeInsetsDirectional.symmetric(horizontal: padding),
                  child: SafeArea(
                    child: AppButton(
                      text: 'Clear All',
                      onTap: () {
                        NotificationService.deleteAllNotifications(
                          notifications,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
