import 'package:flutter/material.dart';
import 'package:task_manager/constants.dart';
import 'package:task_manager/layouts/auth_layout.dart';
import 'package:task_manager/modals/snackbar.dart';
import 'package:task_manager/utils.dart';
import 'package:task_manager/widgets/app_button.dart';
import 'package:task_manager/widgets/form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false, submitted = false;

  Future<void> resetPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );
        showSnackbar('Password reset email sent!', MessageType.success);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'invalid-email':
            showSnackbar('The email address is invalid.', MessageType.error);
            break;
          case 'user-not-found':
            showSnackbar('No user found with that email.', MessageType.error);
            break;
          default:
            showSnackbar('Error: ${e.message}', MessageType.error);
        }
      } catch (e) {
        showSnackbar('Something went wrong.', MessageType.error);
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      loading: loading,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reset Password',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: padding * 2),
          Form(
            key: formKey,
            child: AppFormField(
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
          ),
          const SizedBox(height: padding),
          AppButton(
            text: 'Reset Password',
            disabled: loading,
            onTap: () {
              setState(() {
                submitted = true;
              });
              FocusScope.of(context).unfocus();
              formKey.currentState!.validate();
              resetPassword();
            },
          ),
          const SizedBox(height: padding * 2),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Remembered your password? ',
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
