import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/pages/home.dart';
import 'package:proxima_parada_mobile/pages/welcome.dart';
import 'package:proxima_parada_mobile/theme/theme.dart'; // Importe o arquivo de temas

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['APIKEY']!,
      appId: dotenv.env['APPID']!,
      messagingSenderId: dotenv.env['MESSAGINGSENDERID']!,
      projectId: dotenv.env['PROJECTIR']!,
      storageBucket: dotenv.env['STORAGEBUCKET']!,
    ),
  );

  final currentUser = await FirebaseService().getCurrentUser();

  runApp(MaterialApp(
    home: currentUser != null ?  const Home() :  const Welcome(),
    debugShowCheckedModeBanner: true,
    theme: AppThemes.lightTheme, // Use o tema claro
    // darkTheme: AppThemes.darkTheme,
    // themeMode: ThemeMode.system,
  ));
}
