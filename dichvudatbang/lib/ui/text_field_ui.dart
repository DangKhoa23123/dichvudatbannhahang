import 'package:flutter/material.dart';

class TextFieldUi extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String labelText;

  const TextFieldUi({
    Key? key,
    required this.controller,
    required this.obscureText,
    required this.labelText, // giá trị mặc định nếu không truyền
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
