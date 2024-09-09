import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/services/image_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/user_vehicle.dart';
import 'package:proxima_parada_mobile/utils/form_utils.dart';
import 'package:proxima_parada_mobile/utils/upper_case_text_formater.dart';
import 'package:proxima_parada_mobile/widget/custom_text_form_field.dart';

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

  bool _loading = false;
  String _imageUserStandard =
      'https://firebasestorage.googleapis.com/v0/b/proxima-parada-001.appspot.com/o/images%2Fselect-image-icon.jpg?alt=media&token=46e45aee-da26-4d75-9530-87bbe4c5a78d';

  XFile? _pickedImage;

  LocalUser localUser = LocalUser.empty();
  UserVehicle userVehicle = UserVehicle.empty();

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
        setState(() {
          localUser =
              LocalUser.fromMap(userData.data() as Map<String, dynamic>);
          userVehicle = localUser.userVehicle ?? UserVehicle.empty();
          _brandController.text = userVehicle.brand ?? '';
          _modelController.text = userVehicle.model ?? '';
          _colorController.text = userVehicle.color ?? '';
          _plateController.text = userVehicle.plate ?? '';
          _imageUserStandard = userVehicle.imageLocation ?? _imageUserStandard;
        });
      }
    } catch (e) {
      showSnackBar(context, 'Erro ao carregar os dados do usuário: $e');
    }
  }

  void _submitForm(BuildContext context) async {
    if (!validateForm(_formKey)) {
      setState(() => _loading = false);
      return;
    }

    setState(() => _loading = true);

    try {
      if (_pickedImage != null) {
        userVehicle.imageLocation = await ImageService.uploadImage(
            widget.userId, _pickedImage!.path,
            isCar: true);
      }
      _saveChanges();
    } catch (e) {
      setState(() => _loading = false);
      showSnackBar(
          context, 'Erro ao salvar as alterações. Tente novamente mais tarde.');
    }
  }

  void _saveChanges() async {
    userVehicle
      ..brand = _brandController.text
      ..model = _modelController.text
      ..color = _colorController.text
      ..plate = _plateController.text;

    localUser.userVehicle = userVehicle;

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
        title: Text(
          userVehicle.plate != null ? "Editar veículo" : "Salvar veículo",
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _showBottomSheet(context),
                child: _pickedImage != null
                    ? Image.file(File(_pickedImage!.path),
                        width: 350, height: 350)
                    : Image.network(_imageUserStandard,
                        width: 350, height: 350),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    CustomTextFormField(
                      controller: _brandController,
                      labelText: 'Marca',
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: _modelController,
                      labelText: 'Modelo',
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: _colorController,
                      labelText: 'Cor',
                    ),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      controller: _plateController,
                      labelText: 'Placa',
                      textInputAction: TextInputAction.done,
                      inputFormatters: [UpperCaseTextFormatter()],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        onPressed: () => _submitForm(context),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45),
                          backgroundColor: Colors.blue,
                        ),
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                userVehicle.plate != null
                                    ? 'Salvar Alterações'
                                    : 'Salvar Veículo',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
