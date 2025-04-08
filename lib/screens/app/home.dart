import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/widgets/profile_info.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(padding),
      children: [ProfileInfo()],
    );
  }
}
