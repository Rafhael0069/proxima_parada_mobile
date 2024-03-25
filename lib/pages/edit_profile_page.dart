import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/utils/validator.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  EditProfilePage({required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseService _fbServices = FirebaseService();
  String _imageUserStandard =
      'https://firebasestorage.googleapis.com/v0/b/proxima-parada-001.appspot.com/o/images%2Fusers%2Fuser_avatar.png?alt=media&token=2974efa6-3ead-462d-b0a7-0b76b2eb70e4';

  final ImagePicker _picker = ImagePicker();
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
                onTap: () {
                  _selectImage(true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Galeria'),
                onTap: () {
                  _selectImage(false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _selectImage(bool camera) async {
    XFile? imagemSelecionada;
    if (camera) {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.camera);
    } else {
      imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      _pickedImage = imagemSelecionada;
    });
  }

  void _loadUserData() async {
    try {
      DocumentSnapshot? userData = await _fbServices.getUserData(widget.userId, context);
      if (userData != null && userData.exists) {
        // Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
        localUser = LocalUser.fromMap(userData.data() as Map<String, dynamic>);
        setState(() {
          _nameController.text = localUser.name!;
          _emailController.text = localUser.email!;
          if (localUser.locationImage != null) {
            print('ImageUser: ${localUser.locationImage!}');
            _imageUserStandard = localUser.locationImage!;
          }
        });
      }
    } catch (e) {
      print('Erro ao carregar os dados do usuário: $e');
    }
  }

  _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      if (_pickedImage != null) {
        final urlImage = await _fbServices.uploadImage(localUser, _pickedImage!.path);
        localUser.locationImage = urlImage;
        _saveChanges();
        setState(() => _loading = false);
      } else {
        _saveChanges();
        setState(() => _loading = false);
      }
    } else {
      setState(() => _loading = false);
    }
  }

  void _saveChanges() async {
    try {
      localUser.name = _nameController.text.trim();
      localUser.email = _emailController.text.trim();

      await _fbServices.updateUserData(widget.userId, localUser, context);

      // Mostrar uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Informações atualizadas com sucesso!'),
      ));
    } catch (e) {
      print('Erro ao salvar as alterações: $e');
      // Mostrar uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao salvar as alterações. Tente novamente mais tarde.'),
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: mediaQuery.size.height,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(context),
                        child: _pickedImage == null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(_imageUserStandard),
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
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(labelText: 'Nome'),
                              validator: Validator.nome,
                            ),
                          ),
                        ),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            onPressed: () => _submitForm(context),
                            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                            child: _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Salvar Alterações',
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
                    padding: const EdgeInsets.only(top: 16),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       TextField(
      //         controller: _nameController,
      //         decoration: InputDecoration(labelText: 'Nome'),
      //       ),
      //       SizedBox(height: 10),
      //       TextField(
      //         controller: _emailController,
      //         decoration: InputDecoration(labelText: 'Email'),
      //       ),
      //       SizedBox(height: 10),
      //     ],
      //   ),
      // ),
    );
  }
}
