import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';
import 'package:ticketing_flutter/modules/auth/widgets/auth_button.dart';
import 'package:ticketing_flutter/modules/auth/widgets/hero_login.dart';
import 'package:ticketing_flutter/modules/auth/widgets/login_form.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
          child: ListView(
            children: [
              HeroLogin(),
              LoginForm(
                emailController: emailController,
                passwordController: passwordController,
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    final userRole = state.user.role?.name.toLowerCase();
                    
                    if (userRole == 'admin') {
                      Navigator.pushReplacementNamed(context, '/admin');
                    } else {
                      Navigator.pushReplacementNamed(context, '/user');
                    }
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return AuthButton(
                    text: "Sign In",
                    onPressed: () {
                      final email = emailController.text;
                      final password = passwordController.text;
                      context.read<AuthBloc>().add(
                        LoginSubmitted(email, password),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
