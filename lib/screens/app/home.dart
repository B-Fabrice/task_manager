import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/modal_layout.dart';
import 'package:task_manager/services/task_service.dart';
import 'package:task_manager/widgets/form_field.dart';
import 'package:task_manager/widgets/profile_info.dart';
import 'package:task_manager/widgets/task_card.dart';

class Home extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const Home({required this.scaffoldKey, super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  final controller = TextEditingController();
  String query = '';
  SortBy sortBy = SortBy.date;
  String order = 'asc';

  void showSortModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (context) {
        final sorts = [
          ListItem(title: 'Status', value: SortBy.status),
          ListItem(title: 'Priority', value: SortBy.priority),
          ListItem(title: 'Date', value: SortBy.date),
        ];
        final orders = [
          ListItem(title: 'Ascending', value: 'asc'),
          ListItem(title: 'Descending', value: 'desc'),
        ];
        return ListView(
          padding: EdgeInsets.all(padding),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Text('Sort by', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: padding / 2),
            ...sorts.map((item) {
              return ListTile(
                title: Text(item.title),
                minTileHeight: 10,
                onTap: () {
                  setState(() {
                    sortBy = item.value;
                  });
                  Navigator.pop(context);
                },
                trailing: Radio<SortBy>(
                  value: item.value,
                  groupValue: sortBy,
                  onChanged: (value) {
                    setState(() {
                      sortBy = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            }),
            const SizedBox(height: padding),
            Text('Order', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: padding / 2),
            ...orders.map((item) {
              return ListTile(
                title: Text(item.title),
                minTileHeight: 10,
                onTap: () {
                  setState(() {
                    sortBy = item.value;
                  });
                  Navigator.pop(context);
                },
                trailing: Radio<String>(
                  value: item.value,
                  groupValue: order,
                  onChanged: (value) {
                    setState(() {
                      order = value!;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasksStream = ref.watch(TaskService.tasksStream);
    final tasks = tasksStream.value ?? [];

    switch (sortBy) {
      case SortBy.status:
        tasks.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
      case SortBy.priority:
        tasks.sort((a, b) => a.priority.index.compareTo(b.priority.index));
        break;
      case SortBy.date:
        tasks.sort((a, b) => a.date.compareTo(b.date));
        break;
    }

    if (order == 'desc') {
      tasks.sort((a, b) => b.date.compareTo(a.date));
    }

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
              onTap: showSortModal,
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
