import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';
import 'package:ticketing_flutter/modules/auth/widgets/password_input.dart';
import 'package:ticketing_flutter/modules/auth/widgets/text_input.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextInput(
            controller: emailController,
            label: "Email",
            isEmail: true,
            icon: Icon(Icons.email),
          ),
          SizedBox(height: 32),
          PasswordInput(controller: passwordController, icon: Icon(Icons.lock)),
          SizedBox(height: 32),
          Align(
            alignment: Alignment.bottomRight,
            child: RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: AppColors.primaryLight),
                children: [
                  TextSpan(
                    text: "Sign up",
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
