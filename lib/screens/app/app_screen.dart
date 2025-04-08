import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/modals/add_task_modal.dart';
import 'package:task_manager/screens/app/account.dart';
import 'package:task_manager/screens/app/home.dart';
import 'package:task_manager/screens/auth/login.dart';
import 'package:task_manager/screens/notifications.dart';
import 'package:task_manager/widgets/bottom_bar.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  AppScreenState createState() => AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  int currentIndex = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }

  final List<BarItem> barItems = [
    BarItem('Home', 'system-uicons:home', 0),
    BarItem('Account', 'line-md:account', 1),
  ];

  @override
  Widget build(BuildContext context) {
    final screens = [Home(scaffoldKey: scaffoldKey), Account()];
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const Notifications(),
      floatingActionButton:
          currentIndex == 0
              ? FloatingActionButton(
                backgroundColor: theme.primaryColorDark,
                shape: const CircleBorder(),
                onPressed: () => showAddTaskModal(context),
                child: IconifyIcon(
                  icon: 'lucide:plus',
                  color: theme.scaffoldBackgroundColor,
                ),
              )
              : null,
      body: SafeArea(child: screens[currentIndex]),
      bottomNavigationBar: BottomBar(
        barItems: barItems,
        selectedBarIndex: currentIndex,
        onBarTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
