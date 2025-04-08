import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/modal_layout.dart';
import 'package:task_manager/modals/snackbar.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/services/task_service.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/widgets/app_button.dart';
import 'package:task_manager/widgets/form_field.dart';

void showEditTaskModal(BuildContext context, Task task) {
  showGeneralDialog(
    context: context,
    barrierLabel: '',
    barrierDismissible: true,
    pageBuilder: (context, animate, secondAnimate) {
      return EditTaskModal(task: task);
    },
  );
}

class EditTaskModal extends ConsumerStatefulWidget {
  final Task task;
  const EditTaskModal({required this.task, super.key});

  @override
  ConsumerState<EditTaskModal> createState() => _EditTaskModalState();
}

class _EditTaskModalState extends ConsumerState<EditTaskModal> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? date;
  TaskPriority priority = TaskPriority.medium;
  TaskStatus status = TaskStatus.pending;
  bool loading = false, submitted = false, isEdit = false;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    titleController.text = task.title;
    descriptionController.text = task.description;
    date = task.date;
    priority = task.priority;
    status = task.status;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> handlePick() async {
    if (!isEdit) return;
    FocusScope.of(context).unfocus();
    final result = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (result != null && mounted) {
      final timeResult = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(result),
      );
      if (timeResult != null) {
        setState(() {
          date = DateTime(
            result.year,
            result.month,
            result.day,
            timeResult.hour,
            timeResult.minute,
          );
        });
      }
    }
  }

  Future<void> addTask() async {
    if (formKey.currentState?.validate() == true && date != null) {
      setState(() {
        loading = true;
      });
      try {
        final data = {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'priority': priority.name,
          'date': Timestamp.fromDate(date!),
          'status': status.name,
        };
        await TaskService.updateTask(widget.task.id, data);
        showSnackbar('Task updated successfully', MessageType.success);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        showSnackbar('Error updating task', MessageType.error);
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priorities = [
      ListItem(title: 'High', value: TaskPriority.high),
      ListItem(title: 'Medium', value: TaskPriority.medium),
      ListItem(title: 'Low', value: TaskPriority.low),
    ];

    final statuses = [
      ListItem(title: 'Pending', value: TaskStatus.pending),
      ListItem(title: 'In Progress', value: TaskStatus.inProgress),
      ListItem(title: 'Completed', value: TaskStatus.completed),
    ];
    return ModalLayout(
      loading: loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              isEdit ? 'Edit Task' : 'Task Details',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ),
          SizedBox(height: padding * 2),
          Form(
            key: formKey,
            child: Column(
              children: [
                AppFormField(
                  controller: titleController,
                  readOnly: !isEdit,
                  label: 'Title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                  onChange: (value) {
                    if (submitted) {
                      formKey.currentState?.validate();
                    }
                  },
                ),
                SizedBox(height: padding),
                AppFormField(
                  controller: descriptionController,
                  label: 'Description',
                  readOnly: !isEdit,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Description is required';
                    }
                    return null;
                  },
                  onChange: (value) {
                    if (submitted) {
                      formKey.currentState?.validate();
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: padding),
          if (isEdit) ...[
            Text('Priority:', style: theme.textTheme.titleSmall),
            Padding(
              padding: const EdgeInsets.only(left: padding),
              child: Column(
                children: [
                  ...priorities.map((mode) {
                    return ListTile(
                      minTileHeight: 10,
                      enabled: isEdit,
                      title: Text(
                        mode.title,
                        style: theme.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        setState(() {
                          priority = mode.value;
                        });
                      },
                      trailing: Radio<TaskPriority>(
                        value: mode.value,
                        groupValue: priority,
                        onChanged: (value) {
                          if (!isEdit) return;
                          setState(() {
                            priority = value!;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: padding),
            Text('Status:', style: theme.textTheme.titleSmall),
            Padding(
              padding: const EdgeInsets.only(left: padding),
              child: Column(
                children: [
                  ...statuses.map((mode) {
                    return ListTile(
                      minTileHeight: 10,
                      enabled: isEdit,
                      title: Text(
                        mode.title,
                        style: theme.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        setState(() {
                          priority = mode.value;
                        });
                      },
                      trailing: Radio<TaskStatus>(
                        value: mode.value,
                        groupValue: status,
                        onChanged: (value) {
                          if (!isEdit) return;
                          setState(() {
                            status = value!;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: padding),
            GestureDetector(
              onTap: handlePick,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date == null ? 'Select Due Date' : formatDateTime(date!),
                    style: theme.textTheme.bodyMedium,
                  ),
                  IconifyIcon(
                    icon: 'tabler:calendar-due',
                    color: theme.primaryColorDark,
                  ),
                ],
              ),
            ),
            SizedBox(height: padding),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Priority:', style: theme.textTheme.titleSmall),
                Text(priority.name, style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Status:', style: theme.textTheme.titleSmall),
                Text(status.name, style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Due Date:', style: theme.textTheme.titleSmall),
                Text(formatDateTime(date!), style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
          SizedBox(height: padding),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AppButton(
                  text: isEdit ? 'Update Task' : 'Edit Task',
                  onTap: () async {
                    if (!isEdit) {
                      setState(() {
                        isEdit = true;
                      });
                      return;
                    }
                    setState(() {
                      submitted = true;
                    });
                    FocusScope.of(context).unfocus();
                    formKey.currentState?.validate();
                    addTask();
                  },
                ),
              ),
              const SizedBox(width: padding),
              Expanded(
                flex: 2,
                child: AppButton(
                  text: 'Cancel',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
