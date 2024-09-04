import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/user_vehicler.dart';
import 'package:proxima_parada_mobile/utils/upper_case_text_formater.dart';

class CreateAndEditVehicle extends StatefulWidget {
  final String userId;

  const CreateAndEditVehicle({Key? key, required this.userId})
      : super(key: key);

  @override
  State<CreateAndEditVehicle> createState() => _CreateAndEditVehicleState();
}

class _CreateAndEditVehicleState extends State<CreateAndEditVehicle> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final FirebaseService _fbServices = FirebaseService();

  bool _loading = false;
  String _imageUserStandard =
      'https://firebasestorage.googleapis.com/v0/b/proxima-parada-001.appspot.com/o/images%2Fselect-image-icon.jpg?alt=media&token=46e45aee-da26-4d75-9530-87bbe4c5a78d';

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;

  LocalUser localUser = LocalUser.empty();
  UserVehicle userVehicle = UserVehicle.empty();

  @override
  void initState() {
    _loadUserData();
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
      DocumentSnapshot? userData =
          await _fbServices.getUserData(widget.userId, context);
      if (userData != null && userData.exists) {
        localUser = LocalUser.fromMap(userData.data() as Map<String, dynamic>);
        userVehicle = localUser.userVehicle!;
        if (userVehicle.plate != null) {
          setState(() {
            _brandController.text = userVehicle.brand!;
            _modelController.text = userVehicle.model!;
            _colorController.text = userVehicle.color!;
            _plateController.text = userVehicle.plate!;
            _imageUserStandard = userVehicle.imageLocation!;
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar os dados do usuário: $e');
    }
  }

  _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
      if (_pickedImage != null) {
        final urlImage = await _fbServices
            .uploadImage(localUser, _pickedImage!.path, isCar: true);
        userVehicle.imageLocation = urlImage;
        _saveChanges();
      } else {
        _saveChanges();
      }
    } else {
      setState(() => _loading = false);
    }
  }

  void _saveChanges() async {
    userVehicle.brand = _brandController.text;
    userVehicle.model = _modelController.text;
    userVehicle.color = _colorController.text;
    userVehicle.plate = _plateController.text;
    try {
      localUser.userVehicle = userVehicle;
      await _fbServices.updateUserData(widget.userId, localUser, context);

      // Mostrar uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Informações atualizadas com sucesso!'),
      ));
    } catch (e) {
      setState(() => _loading = false);
      // Mostrar uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Erro ao salvar as alterações. Tente novamente mais tarde.'),
      ));
    }
    setState(() => _loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            userVehicle.plate != null ? "Editar veículo" : "Salvar veículo"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context),
                      child: _pickedImage != null
                          ? Image(
                              image: FileImage(File(_pickedImage!.path)),
                              width: 350,
                              height: 350,
                            )
                          : Image(
                              image: NetworkImage(_imageUserStandard),
                              width: 350,
                              height: 350,
                            ),
                    )),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextFormField(
                            controller: _brandController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration:
                                const InputDecoration(labelText: 'Marca'),
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextFormField(
                            controller: _modelController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration:
                                const InputDecoration(labelText: 'Modelo'),
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextFormField(
                            controller: _colorController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(labelText: 'Cor'),
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextFormField(
                            controller: _plateController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              UpperCaseTextFormatter(),
                            ],
                            decoration:
                                const InputDecoration(labelText: 'Placa'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: ElevatedButton(
                          onPressed: () => _submitForm(context),
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(45)),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  userVehicle.plate != null
                                      ? 'Salvar Alterações'
                                      : 'Salvar Veículo',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
