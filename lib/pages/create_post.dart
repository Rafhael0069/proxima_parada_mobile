import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/utils/date_time_formator.dart';

class CreatePost extends StatefulWidget {
  final String userId;

  const CreatePost({required this.userId});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
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
  final FirebaseService _fbServices = FirebaseService();

  @override
  void initState() {
    _originCityController.text = 'Cidade testes 01';
    _originNeighborhoodController.text = 'Bairro testes 01';
    _originStreetController.text = 'Rua testes 01';
    _originNumberController.text = '01';
    _destinationCityController.text = 'Cidade testes 02';
    _destinationNeighborhoodController.text = 'Bairro testes 02';
    _destinationStreetController.text = 'Rua testes 02';
    _destinationNumberController.text = '02';
    _departureDateController.text = '20/07/2023';
    _departureTimeController.text = '08:00 AM';
    _loadUserData();
    super.initState();
  }

  void _loadUserData() async {
    try {
      DocumentSnapshot? userData = await _fbServices.getUserData(widget.userId, context);
      if (userData != null && userData.exists) {
        // Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
        localUser = LocalUser.fromMap(userData.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Erro ao carregar os dados do usuário: $e');
    }
  }

  _createPublication() async {
    // LocalUser user = localUser?.toMap();
    Publication publication = Publication(
      localUser!.idUser,
      localUser!.name,
      localUser!.locationImage,
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
      true,
      true,
      registrationDate: DateTime.now().toString(),
      atualizationDate: DateTime.now().toString(),
    );
    try {
      await _fbServices.savePublicationData(publication, context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Carona criada com sucesso!'),
      ));
    } catch (e) {
      print('Erro ao salvar as alterações: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao salvar as alterações. Tente novamente mais tarde.'),
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Creação de Postagem")),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "Origem",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              TextField(
                controller: _originCityController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Cidade"),
              ),
              TextField(
                controller: _originNeighborhoodController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Bairro"),
              ),
              TextField(
                controller: _originStreetController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Rua"),
              ),
              TextField(
                controller: _originNumberController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Numero"),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _departureDateController,
                      // keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Data da partida",
                      ),
                      onTap: () async {
                        DateTime? date = DateTime(1900);
                        FocusScope.of(context).requestFocus(FocusNode());
                        date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));
                        _departureDateController.text =
                            DateTimeFormater.formatDataTime(date.toString(), "D");
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: TextField(
                      controller: _departureTimeController,
                      // keyboardType: TextInputType.datetime,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Hora da partida",
                      ),
                      onTap: () async {
                        TimeOfDay? time = TimeOfDay.fromDateTime(DateTime.now());
                        FocusScope.of(context).requestFocus(FocusNode());
                        time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );
                        final localizations = MaterialLocalizations.of(context);
                        _departureTimeController.text = localizations.formatTimeOfDay(time!);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Destino",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              TextField(
                controller: _destinationCityController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Cidade"),
              ),
              TextField(
                controller: _destinationNeighborhoodController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Bairro"),
              ),
              TextField(
                controller: _destinationStreetController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "Rua"),
              ),
              TextField(
                controller: _destinationNumberController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Numero"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _createPublication,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(45)),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(
                      fontSize: 20,
                    ),
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
