import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/widgets/loading.dart';

class AuthLayout extends StatelessWidget {
  final Widget body;
  final bool loading;
  const AuthLayout({required this.body, this.loading = false, super.key});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      progressIndicator: const Loading(),
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: padding,
                horizontal: padding,
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height - padding * 8,
                  ),
                  child: body,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
