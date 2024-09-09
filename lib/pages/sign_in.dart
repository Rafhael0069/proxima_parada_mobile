import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/home.dart';
import 'package:proxima_parada_mobile/pages/sign_up.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';
import 'package:proxima_parada_mobile/utils/validator.dart';
import 'package:proxima_parada_mobile/widget/custom_button.dart';
import 'package:proxima_parada_mobile/widget/custom_text_form_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _loading = false;

  /// Submete o formulário de login e navega para a tela inicial se o login for bem-sucedido.
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      final user = await FirebaseService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text, context);

      if (user != null) {
        _navigateToHome();
      } else {
        // Implementar uma mensagem de erro apropriada
        ShowAlertDialog.showAlertDialog(
            context, 'Falha no login, verifique suas credenciais');
      }
      setState(() => _loading = false);
    }
  }

  /// Navega para a tela inicial após o login.
  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: mediaQuery.size.height,
          child: _loading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLogo(),
              _buildSignInForm(),
              _buildSignUpPrompt(),
            ],
          ),
        ),
      ),
    );
  }

  /// Constrói o widget do logo.
  Widget _buildLogo() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 62.0),
      child: Image(
        image: AssetImage("assets/images/logo.png"),
        width: 150.0,
      ),
    );
  }

  /// Constrói o formulário de login.
  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomTextFormField(
            controller: _emailController,
            labelText: "Email",
            keyboardType: TextInputType.emailAddress,
            validator: Validator.email,
          ),
          const SizedBox(height: 5),
          _buildPasswordField(),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: CustomButton(text: "Entrar", onPressed: _submitForm),
          ),
        ],
      ),
    );
  }

  /// Constrói o campo de senha.
  Widget _buildPasswordField() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
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
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.done,
          validator: Validator.password,
        ),
      ),
    );
  }

  /// Constrói o widget de prompt para cadastro.
  Widget _buildSignUpPrompt() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 16.0, right: 4.0),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUp()),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Ainda não possui uma conta? ",
              style: TextStyle(fontSize: 18.0),
            ),
            Text(
              "Cadastre-se",
              style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
