import 'package:flutter/material.dart';
import 'package:ticketing_flutter/core/constants/app_color.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final Icon icon;
  const PasswordInput({super.key, required this.controller, required this.icon});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: widget.icon,
        labelText: 'Password',
        fillColor: AppColors.lightGrey,
        filled: true,
        labelStyle: TextStyle(color: AppColors.black),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.lightGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
      ),
    );
  }
}