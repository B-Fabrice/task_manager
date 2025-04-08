import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/modals/edit_task_modal.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/utils.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({required this.task, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showEditTaskModal(context, task);
      },
      child: Container(
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: theme.primaryColorDark.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 5),
            Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDateTime(task.date),
                  style: theme.textTheme.bodySmall,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: task.color,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    task.status.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
