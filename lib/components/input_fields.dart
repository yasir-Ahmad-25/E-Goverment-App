import 'package:flutter/material.dart';

class InputFields extends StatelessWidget {
  final TextEditingController input_controller;
  final Text inputlabel;
  final Icon? prefixIcon;
  final IconButton? suffixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  const InputFields({
    super.key,
    required this.input_controller,
    required this.inputlabel,
    required this.prefixIcon,
    required this.suffixIcon,
    required this.isPassword,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: input_controller,
      obscureText: isPassword,

      decoration: InputDecoration(
        label: inputlabel,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
