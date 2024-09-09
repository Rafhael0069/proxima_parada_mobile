import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proxima_parada_mobile/pages/sign_in.dart';
import 'package:proxima_parada_mobile/pages/sign_up.dart';
import 'package:proxima_parada_mobile/widget/custom_button.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  DateTime? _lastPressed;

  void _onPopInvoked(bool didPop) {
    if (!didPop && (_lastPressed == null || DateTime.now().difference(_lastPressed!) > const Duration(seconds: 2))) {
      // Primeira pressionada ou pressionada após 2 segundos
      _lastPressed = DateTime.now();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pressione novamente para sair')),
      );
    } else {
      SystemNavigator.pop(); // Fecha o aplicativo
    }
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: _onPopInvoked,
      child: Scaffold(
        body: Container(
          color: const Color(0xFFEAEAEA), // Cor de fundo conforme o padrão
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 250,
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "O Próxima Parada facilitará o deslocamento entre sua casa e a sua instituição de ensino.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87, // Cor do texto
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: "Entrar",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16), // Espaçamento entre botões
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomButton(
                    text: "Cadastra-se",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
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
