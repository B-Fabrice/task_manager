import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/screens/app/app_screen.dart';
import 'package:task_manager/screens/auth/login.dart';
import 'package:task_manager/screens/storage_service.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/shared_states.dart';
import 'package:task_manager/theme/theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initApp();
  }

  Future<void> initApp() async {
    final auth = FirebaseAuth.instance;
    final mode = await StorageService.getMode();
    if (mode != null) {
      final data = mode == 'dark' ? darkTheme : lightTheme;
      ref.read(themeProvider.notifier).state = data();
    }
    await Future.delayed(const Duration(seconds: 2));
    final nextWidget = auth.currentUser != null ? AppScreen() : Login();
    if (auth.currentUser != null) {
      await NotificationService.initialize();
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return nextWidget;
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 200, height: 200),
            const SizedBox(height: 20),
            Text(
              'Welcome to MyApp',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
