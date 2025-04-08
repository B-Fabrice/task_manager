import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/modal_layout.dart';
import 'package:task_manager/screens/storage_service.dart';
import 'package:task_manager/shared_states.dart';
import 'package:task_manager/theme/theme.dart';

void showModeModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: '',
    barrierDismissible: true,
    pageBuilder: (context, animate, secondAnimate) {
      return ModeModal();
    },
  );
}

class ModeModal extends ConsumerStatefulWidget {
  const ModeModal({super.key});

  @override
  ConsumerState<ModeModal> createState() => _ModeModalState();
}

class _ModeModalState extends ConsumerState<ModeModal> {
  ThemeData? selectedTheme;

  @override
  void initState() {
    super.initState();
    selectedTheme = ref.read(themeProvider);
  }

  Future<void> changeMode(ThemeData? theme) async {
    ref.read(themeProvider.notifier).state = theme;
    await StorageService.setMode(theme?.brightness.name);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modes = [
      ListItem(title: 'Light', value: lightTheme),
      ListItem(title: 'Dark', value: darkTheme),
      ListItem(title: 'System', value: null),
    ];
    return ModalLayout(
      child: Column(
        children: [
          Text('Mode', style: theme.textTheme.titleMedium),
          SizedBox(height: padding * 2),
          ...modes.map((mode) {
            return ListTile(
              title: Text(mode.title, style: theme.textTheme.bodyMedium),
              onTap: () {
                changeMode(mode.value);
              },
              trailing: Radio<ThemeData?>(
                value: mode.value,
                groupValue: selectedTheme,
                onChanged: (value) {
                  changeMode(value);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
