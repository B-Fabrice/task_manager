import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/modal_layout.dart';
import 'package:task_manager/modals/snackbar.dart';
import 'package:task_manager/services/task_service.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/widgets/app_button.dart';
import 'package:task_manager/widgets/form_field.dart';

void showAddTaskModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: '',
    barrierDismissible: true,
    pageBuilder: (context, animate, secondAnimate) {
      return AddTaskModal();
    },
  );
}

class AddTaskModal extends ConsumerStatefulWidget {
  const AddTaskModal({super.key});

  @override
  ConsumerState<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends ConsumerState<AddTaskModal> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? date;
  TaskPriority priority = TaskPriority.medium;
  bool loading = false, submitted = false;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> handlePick() async {
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
        final auth = FirebaseAuth.instance;
        final user = auth.currentUser;
        final data = {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'priority': priority.name,
          'date': Timestamp.fromDate(date!),
          'user': user?.uid,
          'status': TaskStatus.pending.name,
        };
        await TaskService.addTask(data);
        showSnackbar('Task added successfully', MessageType.success);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        showSnackbar('Error adding task', MessageType.error);
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
    return ModalLayout(
      loading: loading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Add Task',
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
          Text('Priority', style: theme.textTheme.titleSmall),
          Padding(
            padding: const EdgeInsets.only(left: padding),
            child: Column(
              children: [
                ...priorities.map((mode) {
                  return ListTile(
                    minTileHeight: 10,
                    title: Text(mode.title, style: theme.textTheme.bodyMedium),
                    onTap: () {
                      setState(() {
                        priority = mode.value;
                      });
                    },
                    trailing: Radio<TaskPriority>(
                      value: mode.value,
                      groupValue: priority,
                      onChanged: (value) {
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
          AppButton(
            text: 'Add Task',
            onTap: () async {
              setState(() {
                submitted = true;
              });
              FocusScope.of(context).unfocus();
              formKey.currentState?.validate();
              addTask();
            },
          ),
        ],
      ),
    );
  }
}
