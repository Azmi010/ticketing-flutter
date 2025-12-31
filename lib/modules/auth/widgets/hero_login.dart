import 'package:flutter/material.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';

class HeroLogin extends StatelessWidget {
  const HeroLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
          ),
          SizedBox(height: 32),
          Text(
            "Welcome Back",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            "Please sign in to your account to continue buying tickets.",
            style: TextStyle(fontSize: 16, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
