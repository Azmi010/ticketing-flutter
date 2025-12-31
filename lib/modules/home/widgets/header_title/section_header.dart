import 'package:flutter/material.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        TextButton(
          onPressed: () {Navigator.pushReplacementNamed(context, '/');},
          child: Text(
            "See All",
            style: TextStyle(color: AppColors.primaryLight),
          ),
        ),
      ],
    );
  }
}
