import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:proxima_parada_mobile/pages/welcome.dart';

Future<void> main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['APIKEY']!, // paste your api key here
      appId: dotenv.env['APPID']!, //paste your app id here
      messagingSenderId: dotenv.env['MESSAGINGSENDERID']!, //paste your messagingSenderId here
      projectId: dotenv.env['PROJECTIR']!, //paste your project id here
    ),
  );

  runApp(const MaterialApp(
    home: Welcome(),
    debugShowCheckedModeBanner: true,
  ));
}
