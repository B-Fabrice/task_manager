import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/services/task_service.dart';
import 'package:task_manager/widgets/form_field.dart';
import 'package:task_manager/widgets/profile_info.dart';
import 'package:task_manager/widgets/task_card.dart';

class Home extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Home({required this.scaffoldKey, super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final controller = TextEditingController();
  String query = '';
  @override
  Widget build(BuildContext context) {
    final tasksStream = ref.watch(TaskService.tasksStream);
    final tasks = tasksStream.value ?? [];
    return ListView(
      padding: EdgeInsets.all(padding),
      shrinkWrap: true,
      children: [
        ProfileInfo(scaffoldKey: widget.scaffoldKey),
        const SizedBox(height: padding),
        Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: padding / 2),
        Row(
          children: [
            Expanded(
              child: AppFormField(
                controller: controller,
                label: 'Search',
                onChange: (value) {
                  setState(() {
                    query = value;
                  });
                },
              ),
            ),
            const SizedBox(width: padding),
            GestureDetector(
              onTap: () {},
              child: IconifyIcon(
                icon: 'material-symbols:sort',
                color: Theme.of(context).iconTheme.color,
                size: 50,
              ),
            ),
          ],
        ),
        const SizedBox(height: padding),
        ListView.separated(
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskCard(task: task);
          },
          separatorBuilder:
              (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Divider(),
              ),
          itemCount: tasks.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ],
    );
  }
}
