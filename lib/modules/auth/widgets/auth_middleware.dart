import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketing_flutter/modules/auth/bloc/auth_bloc.dart';
import 'package:ticketing_flutter/modules/auth/bloc/auth_state.dart';
import 'package:ticketing_flutter/modules/auth/screen/login_screen.dart';
import 'package:ticketing_flutter/modules/nav/screen/navbar_admin_screen.dart';
import 'package:ticketing_flutter/modules/nav/screen/navbar_user_screen.dart';

class AuthMiddleware extends StatelessWidget {
  const AuthMiddleware({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AuthSuccess) {
          final userRole = state.user.role?.name.toLowerCase();
          
          if (userRole == 'admin') {
            return const NavbarAdminScreen();
          } else {
            return const NavbarUserScreen();
          }
        }

        return LoginScreen();
      },
    );
  }
}
