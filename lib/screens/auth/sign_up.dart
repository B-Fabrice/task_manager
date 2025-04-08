import 'package:flutter/material.dart';
import 'package:iconify_design/iconify_design.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/auth_layout.dart';
import 'package:task_manager/modals/snackbar.dart';
import 'package:task_manager/screens/app/app_screen.dart';
import 'package:task_manager/screens/auth/login.dart';
import 'package:task_manager/services/notification_service.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/widgets/app_button.dart';
import 'package:task_manager/widgets/form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false, showPassword = false, submitted = false;

  Future<void> signUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        final auth = FirebaseAuth.instance;
        await auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        await auth.currentUser?.updateProfile(
          displayName: nameController.text.trim(),
        );
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case 'email-already-in-use':
            showSnackbar('Email already in use', MessageType.error);
            break;
          case 'invalid-email':
            showSnackbar('Invalid email address', MessageType.error);
            break;
          case 'operation-not-allowed':
            showSnackbar('Operation not allowed', MessageType.error);
            break;
          case 'weak-password':
            showSnackbar('Weak password', MessageType.error);
            break;
          default:
            showSnackbar(
              'Error creating user: ${error.message}',
              MessageType.error,
            );
        }
        setState(() {
          loading = false;
        });
        return;
      }
      showSnackbar('Account created successfully', MessageType.success);
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
            'Create an account',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: padding * 2),
          Form(
            key: formKey,
            child: Column(
              children: [
                AppFormField(
                  controller: nameController,
                  label: 'Enter your Name',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                  onChange: (value) {
                    if (submitted) {
                      formKey.currentState!.validate();
                    }
                  },
                ),
                const SizedBox(height: padding),
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
              ],
            ),
          ),
          const SizedBox(height: padding),

          AppButton(
            text: 'Sign Up',
            disabled: loading,
            onTap: () {
              setState(() {
                submitted = true;
              });
              FocusScope.of(context).unfocus();
              formKey.currentState!.validate();
              signUp();
            },
          ),
          const SizedBox(height: padding * 2),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Login();
                  },
                ),
              );
            },
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Already have an account? ',
                style: Theme.of(context).textTheme.labelMedium,
                children: [
                  TextSpan(
                    text: 'Sign In',
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
