import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/utils/validator.dart';

class CustomPasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Function(bool) onVisibilityChanged;
  final String? confirmPassword;

  const CustomPasswordFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    required this.onVisibilityChanged,
    this.confirmPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () => onVisibilityChanged(!obscureText),
            ),
          ),
          validator: (value) {
            if (confirmPassword != null) {
              return Validator.confirmPassword(value, confirmPassword);
            } else {
              return Validator.password(value);
            }
          },
        ),
      ),
    );
  }
}