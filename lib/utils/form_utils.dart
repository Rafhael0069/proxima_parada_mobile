import 'package:flutter/material.dart';

bool validateForm(GlobalKey<FormState> formKey) {
  return formKey.currentState?.validate() ?? false;
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}
