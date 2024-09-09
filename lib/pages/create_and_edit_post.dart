import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/utils/date_time_formator.dart';
import 'package:proxima_parada_mobile/utils/publication_helper.dart';

class CreateAndEditPost extends StatefulWidget {
  final String idUser;
  final Publication? existentPublication;

  const CreateAndEditPost({
    super.key,
    required this.idUser,
    this.existentPublication,
  });

  @override
  State<CreateAndEditPost> createState() => _CreateAndEditPostState();
}

class _CreateAndEditPostState extends State<CreateAndEditPost> {
  final TextEditingController _originCityController = TextEditingController();
  final TextEditingController _originNeighborhoodController = TextEditingController();
  final TextEditingController _originStreetController = TextEditingController();
  final TextEditingController _originNumberController = TextEditingController();
  final TextEditingController _destinationCityController = TextEditingController();
  final TextEditingController _destinationNeighborhoodController = TextEditingController();
  final TextEditingController _destinationStreetController = TextEditingController();
  final TextEditingController _destinationNumberController = TextEditingController();
  final TextEditingController _departureDateController = TextEditingController();
  final TextEditingController _departureTimeController = TextEditingController();

  LocalUser? localUser;
  late bool newPublication;
  late Publication publicationData;

  @override
  void initState() {
    super.initState();
    newPublication = widget.existentPublication == null;
    if (!newPublication) {
      publicationData = widget.existentPublication!;
      _initializeControllersWithExistingData(publicationData);
    }
    _loadUserData();
  }

  void _initializeControllersWithExistingData(Publication publication) {
    _originCityController.text = publication.originCity!;
    _originNeighborhoodController.text = publication.originNeighborhood!;
    _originStreetController.text = publication.originStreet!;
    _originNumberController.text = publication.originNumber!;
    _destinationCityController.text = publication.destinationCity!;
    _destinationNeighborhoodController.text = publication.destinationNeighborhood!;
    _destinationStreetController.text = publication.destinationStreet!;
    _destinationNumberController.text = publication.destinationNumber!;
    _departureDateController.text = publication.departureDate!;
    _departureTimeController.text = publication.departureTime!;
  }

  void _loadUserData() async {
    try {
      DocumentSnapshot? userData = await FirebaseService.getUserData(widget.idUser, context);
      if (userData != null && userData.exists) {
        localUser = LocalUser.fromMap(userData.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Erro ao carregar os dados do usuário: $e');
    }
  }

  // Valida se todos os campos obrigatórios foram preenchidos
  bool _validateFields() {
    if (_originCityController.text.isEmpty ||
        _originNeighborhoodController.text.isEmpty ||
        _originStreetController.text.isEmpty ||
        _originNumberController.text.isEmpty ||
        _destinationCityController.text.isEmpty ||
        _destinationNeighborhoodController.text.isEmpty ||
        _destinationStreetController.text.isEmpty ||
        _destinationNumberController.text.isEmpty ||
        _departureDateController.text.isEmpty ||
        _departureTimeController.text.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos obrigatórios.');
      return false;
    }
    return true;
  }

  Future<void> _createOrUpdatePublication() async {
    if (!_validateFields()) return; // Valida os campos antes de prosseguir

    // Converte data e hora para Timestamp (método movido para PublicationHelper)
    Timestamp timestamp = PublicationHelper.converterDataHoraParaTimestamp(
      _departureDateController.text,
      _departureTimeController.text,
    );

    Publication publication = Publication(
      localUser!.idUser,
      localUser!.name,
      localUser!.phoneNumber,
      localUser!.imageLocation,
      _originCityController.text,
      _originNeighborhoodController.text,
      _originStreetController.text,
      _originNumberController.text,
      _destinationCityController.text,
      _destinationNeighborhoodController.text,
      _destinationStreetController.text,
      _destinationNumberController.text,
      _departureDateController.text,
      _departureTimeController.text,
      timestamp,
      true,
      true,
      updatedDate: DateTime.now().toString(),
    );

    if (!newPublication) {
      publication.registrationDate = publicationData.registrationDate;
      publication.idPublication = publicationData.idPublication;
    } else {
      publication.registrationDate = DateTime.now().toString();
    }

    try {
      if (!newPublication) {
        await FirebaseService.savePublicationData(
          publication,
          context,
          update: publication.toMap(),
        );
        _showSnackBar('Carona atualizada com sucesso!');
      } else {
        await FirebaseService.savePublicationData(publication, context);
        _showSnackBar('Carona criada com sucesso!');
      }
    } catch (e) {
      _showSnackBar('Erro ao salvar a postagem. Tente novamente mais tarde.');
    }
    Navigator.pop(context);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputAction textInputAction = TextInputAction.next,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criação de Postagem",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "Origem",
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              _buildTextField(
                controller: _originCityController,
                label: "Cidade",
              ),
              _buildTextField(
                controller: _originNeighborhoodController,
                label: "Bairro",
              ),
              _buildTextField(
                controller: _originStreetController,
                label: "Rua",
              ),
              _buildTextField(
                controller: _originNumberController,
                label: "Número",
                keyboardType: TextInputType.number,
              ),
              Row(
                children: [
                  Flexible(
                    child: _buildTextField(
                      controller: _departureDateController,
                      label: "Data da partida",
                      readOnly: true,
                      onTap: () async {
                        DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          _departureDateController.text =
                              DateTimeFormater.formatDataTime(
                                  date.toString(), "D");
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: _buildTextField(
                      controller: _departureTimeController,
                      label: "Hora da partida",
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          final localizations = MaterialLocalizations.of(context);
                          _departureTimeController.text =
                              localizations.formatTimeOfDay(time);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Destino",
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
              _buildTextField(
                controller: _destinationCityController,
                label: "Cidade",
              ),
              _buildTextField(
                controller: _destinationNeighborhoodController,
                label: "Bairro",
              ),
              _buildTextField(
                controller: _destinationStreetController,
                label: "Rua",
              ),
              _buildTextField(
                controller: _destinationNumberController,
                label: "Número",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _createOrUpdatePublication,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(45),
                    backgroundColor: Colors.blue, // Cor do botão
                  ),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

