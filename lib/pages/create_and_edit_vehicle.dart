import 'dart:io';

import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/utils/upper_case_text_formater.dart';

class CreateAndEditVehicle extends StatefulWidget {
  final String userId;

  const CreateAndEditVehicle({Key? key, required this.userId}) : super(key: key);

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
      'https://firebasestorage.googleapis.com/v0/b/proxima-parada-001.appspot.com/o/images%2Fusers%2Fuser_avatar.png?alt=media&token=2974efa6-3ead-462d-b0a7-0b76b2eb70e4';

  var _pickedImage;

  _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Salvar veiculo"),
      ),
      body: SingleChildScrollView(
        child: Container(
            height: mediaQuery.size.height,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GestureDetector(
                      onTap: () => {},
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
                            controller: _brandController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(labelText: 'Marca'),
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextFormField(
                            controller: _modelController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(labelText: 'Modelo'),
                          ),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: TextFormField(
                            controller: _plateController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            inputFormatters: [
                              UpperCaseTextFormatter(),
                            ],
                            decoration: const InputDecoration(labelText: 'Placa'),
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
              ],
            )
        ),
      ),
    );
  }
}
