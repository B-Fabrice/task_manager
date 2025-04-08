import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/firebase_options.dart';
import 'package:task_manager/modals/snackbar.dart';
import 'package:task_manager/screens/splash_screen.dart';
import 'package:task_manager/shared_states.dart';
import 'package:task_manager/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Task Manager',
      theme: theme ?? lightTheme(),
      darkTheme: theme ?? darkTheme(),
      scaffoldMessengerKey: messengerKey,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
