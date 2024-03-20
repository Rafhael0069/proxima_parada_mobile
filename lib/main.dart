import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/welcome.dart';

Future<void> main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const MaterialApp(
    home: Welcome(),
    debugShowCheckedModeBanner: true,
  ));
}
