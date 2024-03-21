import 'dart:io';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/home.dart';
import 'package:proxima_parada_mobile/pages/signin.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';
import 'package:proxima_parada_mobile/utils/validator.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerOccupation = TextEditingController();
  final _imageUserStandard = const AssetImage('assets/images/user_avatar.png');

  final _pickedImage = null;

  String _name = '';
  int _age = 0;
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  bool _loading = false;

  @override
  void initState() {
    _controllerEmail.text = "teste3@gmail.com";
    // _controllerPassword.text = "123456";
    // _controllerPassword2.text = "123456";
    _controllerName.text = "nome 3 teste";
    _controllerOccupation.text = "ocupação 3 teste";
    super.initState();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  // Ação quando "Câmera" é selecionada
                  Navigator.pop(context); // Fecha o Bottom Sheet
                  ShowAlertDialog.showAlertDialog(context, "Ainda não implementado :(");
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galeria'),
                onTap: () {
                  // Ação quando "Galeria" é selecionada
                  Navigator.pop(context); // Fecha o Bottom Sheet
                  ShowAlertDialog.showAlertDialog(context, "Ainda não implementado :(");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _directToHome();
    }
  }

  void _directToHome() {
    // ShowAlertDialog.showAlertDialog(context, "Ainda não implementado :(");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()),
        (Route<dynamic> route) => false);
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
                              onTap: () => _showBottomSheet(context),
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
                                    ),
                            )),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(labelText: 'Nome'),
                                    validator: Validator.nome,
                                    onSaved: (value) {
                                      _name = value!;
                                    },
                                  ),
                                ),
                              ),
                              // Container(
                              //   clipBehavior: Clip.antiAlias,
                              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(horizontal: 6),
                              //     child: TextFormField(
                              //       textInputAction: TextInputAction.next,
                              //       decoration: const InputDecoration(labelText: 'Idade'),
                              //       keyboardType: TextInputType.datetime,
                              //       validator: (value) {
                              //         if (value == null || value.isEmpty) {
                              //           return 'Por favor, digite sua idade';
                              //         }
                              //         return null;
                              //       },
                              //       onSaved: (value) {
                              //         _age = int.parse(value!);
                              //       },
                              //     ),
                              //   ),
                              // ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(labelText: 'Email'),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: Validator.email,
                                    onSaved: (value) {
                                      _email = value!;
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _controllerPassword,
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                      labelText: 'Senha',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible = !_passwordVisible;
                                          });
                                        },
                                      ),
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: Validator.password,
                                    onSaved: (value) {
                                      _password = value!;
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    obscureText: !_passwordVisible2,
                                    decoration: InputDecoration(
                                        labelText: 'Confirme a Senha',
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible2
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible2 = !_passwordVisible2;
                                            });
                                          },
                                        )),
                                    textInputAction: TextInputAction.done,
                                    validator: (value) =>
                                        Validator.confirmPassword(value, _controllerPassword.text),
                                    onSaved: (value) {
                                      _confirmPassword = value!;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(45)),
                                  child: const Text(
                                    'Cadastre-se',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
