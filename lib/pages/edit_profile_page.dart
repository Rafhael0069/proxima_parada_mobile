import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/services/image_service.dart';
import 'package:proxima_parada_mobile/utils/form_utils.dart';
import 'package:proxima_parada_mobile/utils/validator.dart';
import 'package:proxima_parada_mobile/widget/custom_text_form_field.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final MaskedTextController _phoneController =
      MaskedTextController(mask: '(00) 0 0000-0000');
  final TextEditingController _emailController = TextEditingController();

  String _imageUserStandard =
      'https://firebasestorage.googleapis.com/v0/b/proxima-parada-001.appspot.com/o/images%2Fselect-image-icon.jpg?alt=media&token=46e45aee-da26-4d75-9530-87bbe4c5a78d';
  XFile? _pickedImage;
  bool _loading = false;

  LocalUser localUser = LocalUser.empty();

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
                onTap: () async {
                  _pickedImage =
                      await ImageService.selectImage(fromCamera: true);
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galeria'),
                onTap: () async {
                  _pickedImage =
                      await ImageService.selectImage(fromCamera: false);
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _loadUserData() async {
    try {
      DocumentSnapshot? userData =
          await FirebaseService.getUserData(widget.userId, context);
      if (userData != null && userData.exists) {
        localUser = LocalUser.fromMap(userData.data() as Map<String, dynamic>);
        setState(() {
          _nameController.text = localUser.name ?? '';
          _phoneController.text = localUser.phoneNumber ?? '';
          _emailController.text = localUser.email ?? '';
          _imageUserStandard = localUser.imageLocation ?? _imageUserStandard;
        });
      }
    } catch (e) {
      showSnackBar(context, 'Erro ao carregar os dados do usuário: $e');
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (!validateForm(_formKey)) {
      setState(() => _loading = false);
      return;
    }

    setState(() => _loading = true);

    try {
      if (_pickedImage != null) {
        final urlImage = await ImageService.uploadImage(
            localUser.idUser!, _pickedImage!.path);
        localUser.imageLocation = urlImage;
      }
      _saveChanges();
    } catch (e) {
      setState(() => _loading = false);
      showSnackBar(
          context, 'Erro ao salvar as alterações. Tente novamente mais tarde.');
    }
  }

  void _saveChanges() async {
    localUser
      ..name = _nameController.text.trim()
      ..phoneNumber = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    try {
      await FirebaseService.updateUserData(widget.userId, localUser, context);
      showSnackBar(context, 'Informações atualizadas com sucesso!');
      Navigator.pop(context);
    } catch (e) {
      showSnackBar(
          context, 'Erro ao salvar as alterações. Tente novamente mais tarde.');
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 40),
                  child: GestureDetector(
                    onTap: () => _showBottomSheet(context),
                    child: CircleAvatar(
                      backgroundImage: _pickedImage != null
                          ? Image.file(File(_pickedImage!.path)).image
                          : NetworkImage(_imageUserStandard),
                      backgroundColor: Colors.white,
                      radius: 150,
                    ),
                  ),
                ),
                const SizedBox(height: 50,),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      CustomTextFormField(
                        controller: _nameController,
                        labelText: 'Nome',
                        validator: Validator.name,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _phoneController,
                        labelText: 'Telefone',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: Validator.phone,
                      ),
                      const SizedBox(height: 10),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validator.email,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          backgroundColor: Colors.blue,
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : const Text(
                          'Salvar Alterações',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
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
