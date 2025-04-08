import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/auth_layout.dart';
import 'package:task_manager/modals/snackbar.dart';
import 'package:task_manager/screens/app/app_screen.dart';
import 'package:task_manager/screens/auth/forgot_password.dart';
import 'package:task_manager/screens/auth/sign_up.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/widgets/app_button.dart';
import 'package:task_manager/widgets/form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false, showPassword = false, submitted = false;

  Future<void> signIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        final auth = FirebaseAuth.instance;
        await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } catch (e) {
        showSnackbar('Invalid email or password', MessageType.error);
        setState(() {
          loading = false;
        });
        return;
      }
      await NotificationService.initialize();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return AppScreen();
          },
        ),
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final auth = FirebaseAuth.instance;
    auth.signOut();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = showPassword ? 'iconoir:eye' : 'fluent:eye-off-16-regular';
    return AuthLayout(
      loading: loading,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome Back',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: padding * 2),
          Form(
            key: formKey,
            child: Column(
              children: [
                AppFormField(
                  controller: emailController,
                  label: 'Enter your Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => isValidEmail(value),
                  textInputAction: TextInputAction.next,
                  onChange: (value) {
                    if (submitted) {
                      formKey.currentState!.validate();
                    }
                  },
                ),
                const SizedBox(height: padding),
                AppFormField(
                  controller: passwordController,
                  label: 'Password',
                  obscureText: !showPassword,
                  textInputAction: TextInputAction.done,
                  validator: (value) => isValidPassword(value),
                  onChange: (value) {
                    if (submitted) {
                      formKey.currentState!.validate();
                    }
                  },
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: IconifyIcon(
                      icon: icon,
                      size: 24,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
                const SizedBox(height: padding),
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ForgotPassword();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: padding),
          AppButton(
            text: 'Sign In',
            disabled: loading,
            onTap: () {
              setState(() {
                submitted = true;
              });
              formKey.currentState!.validate();
              signIn();
            },
          ),
          const SizedBox(height: padding * 2),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUp();
                  },
                ),
              );
            },
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: Theme.of(context).textTheme.labelMedium,
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
