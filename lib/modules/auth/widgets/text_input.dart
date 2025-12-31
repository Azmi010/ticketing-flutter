import 'package:flutter/material.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final Icon icon;
  final String label;
  final bool isEmail;
  const TextInput({
    super.key,
    required this.controller,
    required this.label,
    required this.isEmail,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: label,
        fillColor: AppColors.lightGrey,
        filled: true,
        labelStyle: TextStyle(color: AppColors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
      ),
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
    );
  }
}
