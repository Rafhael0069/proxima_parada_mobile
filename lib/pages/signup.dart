// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/signin.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPassword2 = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerOccupation = TextEditingController();
  final _imageUserStandard = const AssetImage('assets/images/user_avatar.png');

  final _pickedImage = null;

  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  final bool _loading = false;

  @override
  void initState() {
    _controllerEmail.text = "teste3@gmail.com";
    _controllerPassword.text = "123456";
    _controllerPassword2.text = "123456";
    _controllerName.text = "nome 3 teste";
    _controllerOccupation.text = "ocupação 3 teste";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: mediaQuery.size.height,
            padding: const EdgeInsets.all(16),
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image(image: _imageUser),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GestureDetector(
                              onTap: () => ShowAlertDialog.showAlertDialog(
                                  context, "Ainda não implementado :("),
                              child: _pickedImage == null
                                ? CircleAvatar(
                              backgroundImage: _imageUserStandard,
                              backgroundColor: Colors.white,
                              radius: 100,
                            )
                                : CircleAvatar(
                              backgroundImage: Image.file(File(_pickedImage!.path)).image,
                              backgroundColor: Colors.white,
                              radius: 100,
                            ),)),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: TextField(
                              controller: _controllerName,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                  labelText: "Nome", hintText: "Digite o seu nome"),
                            ),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: TextField(
                              controller: _controllerOccupation,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                  labelText: "Ocupação", hintText: "Digite a sua ocupação"),
                            ),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              controller: _controllerEmail,
                              decoration: const InputDecoration(
                                  labelText: "E-mail", hintText: "Digite o seu e-mail"),
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
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              obscureText: !_passwordVisible2,
                              controller: _controllerPassword2,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                labelText: "Confirme sua senha",
                                hintText: "Digite a sua senha novamente",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible2 ? Icons.visibility : Icons.visibility_off,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible2 = !_passwordVisible2;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            //Buttom Signin
                            onPressed: () => ShowAlertDialog.showAlertDialog(
                                context, "Ainda não implementado :("),
                            // onPressed: () => _createUser(),
                            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                            child: const Text(
                              "Cadastra-se",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, top: 16, right: 4),
                          child: GestureDetector(
                            //Buttom Signup
                            onTap: () => Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const Signin())),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Já tem uma conta? ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  "Entre",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.blue),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
