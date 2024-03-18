// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _passwordVisible = false;
  bool _loading = false;

  @override
  void initState() {
    _controllerEmail.text = "teste2@gmail.com";
    _controllerPassword.text = "123456";
    super.initState();
  }

  _login() async {
    _directToHome();
  }

  _directToHome() {
    ShowAlertDialog.showAlertDialog(context,"Ainda não implementado :(");
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()),
    //     (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Entrar"),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _controllerEmail,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: "E-mail",
                            hintText: "Digite o seu e-mail",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          obscureText: !_passwordVisible,
                          controller: _controllerPassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: "Senha",
                            hintText: "Digite a sua senha",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16,
                      ),
                      child: ElevatedButton(
                        onPressed: () => _login(),
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
                      padding: const EdgeInsets.only(left: 4, top: 16, right: 4),
                      child: GestureDetector(
                        onTap: () => ShowAlertDialog.showAlertDialog(context,"Ainda não implementado :("),
                            // () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Signup())),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Ainda não possui uma conta? ",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              "Cadaste-se",
                              style: TextStyle(
                                  fontSize: 18, fontStyle: FontStyle.italic, color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
