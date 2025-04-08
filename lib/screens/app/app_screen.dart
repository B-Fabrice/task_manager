import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/screens/app/account.dart';
import 'package:task_manager/screens/app/home.dart';
import 'package:task_manager/screens/auth/login.dart';
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
    BarItem('Home', 'cinnamon:home-bold', 0),
    BarItem('Account', 'line-md:account', 1),
  ];

  final screens = [Home(), Account()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
