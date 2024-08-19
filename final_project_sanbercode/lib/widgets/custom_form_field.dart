import 'package:final_project_sanbercode/const/palllete.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isObscured;

  const CustomFormField({
    super.key,
    required this.text,
    required this.controller,
    this.keyboardType = TextInputType.text, 
    this.isObscured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 300,
        ),
        child: TextFormField(
          obscureText: isObscured,
          controller: controller,
          keyboardType: keyboardType, // Use the keyboardType here
          decoration: InputDecoration(
            labelText: text,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallete.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Pallete.secondary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
