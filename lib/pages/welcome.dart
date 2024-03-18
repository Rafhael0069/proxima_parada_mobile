import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/signin.dart';
import 'package:proxima_parada_mobile/pages/signup.dart';
import 'package:proxima_parada_mobile/utils/exit.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final AssetImage _imageLogo = const AssetImage("assets/images/logo.png");

  @override
  Widget build(BuildContext context) {
    DateTime timeBackPressed = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        return Exit().isExitToDoubleTouch(isExitWarning);
      },
      child: Scaffold(
        body: Container(
          color: const Color.fromARGB(255, 234, 234, 234),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: _imageLogo,
                  width: 250,
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "O Próxima Parada facilitará o deslocamento entre sua casa e a sua instituição de ensino.",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const Signin()));
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6, right: 16),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const Signup())),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                    child: const Text(
                      "Cadastra-se",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
