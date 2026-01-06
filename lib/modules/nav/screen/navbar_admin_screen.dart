import 'package:flutter/material.dart';

class NavbarAdminScreen extends StatelessWidget {
  const NavbarAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton(onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        }),
      ),
    );
  }
}