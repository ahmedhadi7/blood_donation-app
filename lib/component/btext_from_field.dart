import 'package:flutter/material.dart';

class BTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final IconData? suffixIcon;
  final int maxLines;
  final String? Function(String?)? validator;

  const BTextFormField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.maxLines = 1,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,

      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: () {},
                icon: Icon(suffixIcon, color: Theme.of(context).primaryColor),
              )
            : null,
      ),
      validator: validator,
    );
  }
}
