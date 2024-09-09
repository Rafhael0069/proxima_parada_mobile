import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/user_vehicle.dart';
import 'package:proxima_parada_mobile/pages/home.dart';
import 'package:proxima_parada_mobile/pages/sign_in.dart';
import 'package:proxima_parada_mobile/utils/validator.dart';
import 'package:proxima_parada_mobile/utils/image_utils.dart';
import 'package:proxima_parada_mobile/widget/custom_text_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '(00) 0 0000-0000');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final ImageProvider _defaultAvatar =
      const AssetImage('assets/images/user_avatar.png');
  XFile? _pickedImage;
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  bool _loading = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: SizedBox(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAvatar(),
                _buildForm(context),
                _buildSignInPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: GestureDetector(
        onTap: () => ImageUtils.showImagePickerOptions(context, _selectImage),
        child: CircleAvatar(
          backgroundImage: _pickedImage == null
              ? _defaultAvatar
              : Image.file(File(_pickedImage!.path)).image,
          backgroundColor: Colors.white,
          radius: 150,
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CustomTextFormField(
              controller: _nameController,
              labelText: 'Nome',
              keyboardType: TextInputType.text,
              validator: Validator.name),
          const SizedBox(height: 5),
          CustomTextFormField(
              controller: _phoneController,
              labelText: 'Telefone',
              keyboardType: TextInputType.number,
              validator: Validator.phone),
          const SizedBox(height: 5),
          CustomTextFormField(
              controller: _emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: Validator.email),
          const SizedBox(height: 5),
          _buildPasswordField(_passwordController, 'Senha', _passwordVisible,
              (visible) {
            setState(() {
              _passwordVisible = visible;
            });
          }),
          const SizedBox(height: 5),
          _buildPasswordField(
              _passwordController2, 'Confirme a Senha', _passwordVisible2,
              (visible) {
            setState(() {
              _passwordVisible2 = visible;
            });
          }, confirmPassword: _passwordController.text),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: () => _submitForm(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                backgroundColor: Colors.blue,
              ),
              child: const Text('Cadastre-se',
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
      TextEditingController controller,
      String label,
      bool isVisible,
      Function(bool) onVisibilityChanged,
      {String? confirmPassword}) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: TextFormField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Theme.of(context).primaryColorDark,
              ),
              onPressed: () => onVisibilityChanged(!isVisible),
            ),
          ),
          validator: confirmPassword != null
              ? (value) => Validator.confirmPassword(value, confirmPassword)
              : Validator.password,
        ),
      ),
    );
  }

  Future<void> _selectImage(bool fromCamera) async {
    XFile? selectedImage = await ImageUtils.pickImage(fromCamera);
    setState(() {
      _pickedImage = selectedImage;
    });
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      LocalUser localUser = LocalUser(
        _nameController.text,
        _phoneController.text.replaceAll(RegExp(r'[^\d]'), ''),
        _emailController.text,
        UserVehicle.empty(),
      );
      final user = await FirebaseService.createUserWithEmailAndPassword(
          localUser, _passwordController.text, context);
      if (user != null) {
        if (_pickedImage != null) {
          final urlImage = await FirebaseService.uploadImage(
              localUser.idUser!, _pickedImage!.path);
          localUser.imageLocation = urlImage.toString();
        }
        await FirebaseService.saveUserData(localUser, context);
        setState(() => _loading = false);
        _directToHome();
      } else {
        setState(() => _loading = false);
      }
    }
  }

  void _directToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildSignInPrompt(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 16, right: 4),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const SignIn())),
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
            ),
          ],
        ),
      ),
    );
  }
}
