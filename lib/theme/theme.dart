import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF007BFF); // Azul primário
  static const Color secondaryColor = Color(0xFF673AB7); // Roxo secundário
  static const Color accentColor = Color(0xFF00BCD4); // Ciano de destaque
  static const Color backgroundColor = Color(0xFFF5F5F5); // Cinza claro de fundo
  static const Color errorColor = Color(0xFFF44336); // Vermelho de erro
}

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
    ),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: AppColors.primaryColor,
      titleTextStyle: TextStyle(color: Colors.white,),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: Colors.grey[900],
    colorScheme: const ColorScheme.dark(
      primary: AppColors.secondaryColor,
      secondary: AppColors.accentColor,
      // Use 'secondary' para a cor de destaque
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.secondaryColor,
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    // Personalize outros elementos do tema escuro aqui
  );
}