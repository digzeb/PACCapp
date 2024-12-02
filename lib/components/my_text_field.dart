import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    super.key, 
    required this.controller, 
    required this.hintText, 
    required this.obscureText, Color? color
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
    controller: controller,
    obscureText: obscureText,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
      fillColor: Colors.grey[200],
      filled: true,
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.grey,
      )
      )
    );
  }
}

