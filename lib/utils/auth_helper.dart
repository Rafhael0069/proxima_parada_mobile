import 'package:flutter/material.dart';

class AuthHelper {
  // Constrói um campo de texto com formatação
  static Widget buildTextFormField(
      TextEditingController controller,
      String label,
      TextInputAction textInputAction, {
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          decoration: InputDecoration(labelText: label),
          validator: validator,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  // Constrói um campo de texto para senha com formatação e botão para mostrar/esconder a senha
  static Widget buildPasswordTextFormField(
      TextEditingController controller,
      bool passwordVisible,
      Function(bool) onVisibilityChanged,
      String? Function(String?)? validator,
      ) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            labelText: 'Senha',
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey, // Cor do ícone
              ),
              onPressed: () => onVisibilityChanged(!passwordVisible),
            ),
          ),
          textInputAction: TextInputAction.done,
          validator: validator,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}