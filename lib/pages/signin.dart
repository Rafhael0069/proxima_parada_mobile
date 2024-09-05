import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/pages/home.dart';
import 'package:proxima_parada_mobile/pages/signup.dart';
import 'package:proxima_parada_mobile/utils/validator.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseService _fbServices = FirebaseService();
  bool _passwordVisible = false;
  bool _loading = false;

  @override
  void initState() {

    // _emailController.text = "teste1@gmail.com";
    // _passwordController.text = "1234abcd";

    // _emailController.text = "joao.silva@example.com";
    // _passwordController.text = "senha123";

    _emailController.text = "maria.santos@example.com";
    _passwordController.text = "segredo123";

    // _emailController.text = "pedro.souza@example.com";
    // _passwordController.text = "pedro123456";

    // _emailController.text = "ana.oliveira@example.com";
    // _passwordController.text = "senhaforte123";

    // _emailController.text = "carlos.pereira@example.com";
    // _passwordController.text = "abcdefg123";

    super.initState();
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      final user = await _fbServices.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text, context);
      if (user != null) {
        _directToHome();
        setState(() => _loading = false);
      } else {
        setState(() => _loading = false);
        // ShowAlertDialog.showAlertDialog(context, 'Falha no login, verifique suas credenciais');
      }
      // _login();
    }
  }

  _directToHome() {
    // ShowAlertDialog.showAlertDialog(context, "Ainda não implementado :(");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    DateTime timeBackPressed = DateTime.now();
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async => true,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: mediaQuery.size.height,
            padding: const EdgeInsets.all(16),
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 62),
                        child: Image(
                          image: AssetImage("assets/images/logo.png"),
                          width: 150,
                        ),
                      ),
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
                                  controller: _emailController,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(labelText: 'Email'),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: Validator.email,
                                ),
                              ),
                            ),
                            Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.text,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
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
                                  textInputAction: TextInputAction.done,
                                  validator: Validator.password,
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
                                  'Entrar',
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
                          onTap: () => Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => const Signup())),
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
      ),
    );
  }
}
