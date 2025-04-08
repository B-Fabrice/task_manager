import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:task_manager/widgets/loading.dart';

class ScreenLayout extends StatelessWidget {
  final Widget child;
  final bool loading;
  const ScreenLayout({required this.child, this.loading = false, super.key});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      progressIndicator: const Loading(),
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: child,
      ),
    );
  }
}
