import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/utils/date_time_formator.dart';

class CreateAndEditPost extends StatefulWidget {
  final String idUser;
  Publication? existentPublication;

  CreateAndEditPost({super.key, required this.idUser, this.existentPublication});

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
  final FirebaseService _fbServices = FirebaseService();
  late bool newPublication;
  late Publication publicationData;

  @override
  void initState() {
    newPublication = widget.existentPublication != null ? false : true;
    if (!newPublication) {
      publicationData = widget.existentPublication!;
      _originCityController.text = publicationData.originCity!;
      _originNeighborhoodController.text = publicationData.originNeighborhood!;
      _originStreetController.text = publicationData.originStreet!;
      _originNumberController.text = publicationData.originNumber!;
      _destinationCityController.text = publicationData.destinationCity!;
      _destinationNeighborhoodController.text = publicationData.destinationNeighborhood!;
      _destinationStreetController.text = publicationData.destinationStreet!;
      _destinationNumberController.text = publicationData.destinationNumber!;
      _departureDateController.text = publicationData.departureDate!;
      _departureTimeController.text = publicationData.departureTime!;
    }
    else {
      var dadosExemplo = [
        {
          "originCity": "London",
          "originNeighborhood": "Westminster",
          "originStreet": "Abbey Road",
          "originNumber": "10",
          "destinationCity": "Paris",
          "destinationNeighborhood": "Montmartre",
          "destinationStreet": "Rue de Rivoli",
          "destinationNumber": "20",
          "departureDate": "2024-04-18",
          "departureTime": "10:30 AM"
        },
        {
          "originCity": "Tokyo",
          "originNeighborhood": "Shinjuku",
          "originStreet": "Kabukicho",
          "originNumber": "7-1",
          "destinationCity": "Kyoto",
          "destinationNeighborhood": "Gion",
          "destinationStreet": "Hanamikoji Dori",
          "destinationNumber": "15",
          "departureDate": "2024-04-20",
          "departureTime": "09:45 AM"
        },
        {
          "originCity": "Sydney",
          "originNeighborhood": "Circular Quay",
          "originStreet": "George Street",
          "originNumber": "30",
          "destinationCity": "Melbourne",
          "destinationNeighborhood": "Fitzroy",
          "destinationStreet": "Brunswick Street",
          "destinationNumber": "40",
          "departureDate": "2024-04-22",
          "departureTime": "11:00 AM"
        },
        {
          "originCity": "Rome",
          "originNeighborhood": "Trastevere",
          "originStreet": "Via della Lungara",
          "originNumber": "55",
          "destinationCity": "Venice",
          "destinationNeighborhood": "San Marco",
          "destinationStreet": "Piazza San Marco",
          "destinationNumber": "25",
          "departureDate": "2024-04-25",
          "departureTime": "12:15 PM"
        },
        {
          "originCity": "Berlin",
          "originNeighborhood": "Mitte",
          "originStreet": "Alexanderplatz",
          "originNumber": "70",
          "destinationCity": "Munich",
          "destinationNeighborhood": "Schwabing",
          "destinationStreet": "Leopoldstraße",
          "destinationNumber": "80",
          "departureDate": "2024-04-27",
          "departureTime": "02:30 PM"
        },
        {
          "originCity": "Madrid",
          "originNeighborhood": "Sol",
          "originStreet": "Gran Vía",
          "originNumber": "90",
          "destinationCity": "Barcelona",
          "destinationNeighborhood": "Gothic Quarter",
          "destinationStreet": "La Rambla",
          "destinationNumber": "100",
          "departureDate": "2024-04-30",
          "departureTime": "03:45 PM"
        },
        {
          "originCity": "Toronto",
          "originNeighborhood": "Downtown",
          "originStreet": "Yonge Street",
          "originNumber": "110",
          "destinationCity": "Vancouver",
          "destinationNeighborhood": "Gastown",
          "destinationStreet": "Water Street",
          "destinationNumber": "120",
          "departureDate": "2024-05-02",
          "departureTime": "04:00 PM"
        },
        {
          "originCity": "Dubai",
          "originNeighborhood": "Downtown Dubai",
          "originStreet": "Sheikh Zayed Road",
          "originNumber": "130",
          "destinationCity": "Abu Dhabi",
          "destinationNeighborhood": "Corniche",
          "destinationStreet": "Corniche Road",
          "destinationNumber": "140",
          "departureDate": "2024-05-05",
          "departureTime": "05:30 PM"
        },
        {
          "originCity": "Seoul",
          "originNeighborhood": "Gangnam",
          "originStreet": "Gangnam-daero",
          "originNumber": "150",
          "destinationCity": "Busan",
          "destinationNeighborhood": "Haeundae",
          "destinationStreet": "Haeundae-ro",
          "destinationNumber": "160",
          "departureDate": "2024-05-08",
          "departureTime": "06:45 PM"
        },
        {
          "originCity": "Moscow",
          "originNeighborhood": "Red Square",
          "originStreet": "Kremlin Embankment",
          "originNumber": "170",
          "destinationCity": "Saint Petersburg",
          "destinationNeighborhood": "Nevsky Prospekt",
          "destinationStreet": "Nevsky Avenue",
          "destinationNumber": "180",
          "departureDate": "2024-05-10",
          "departureTime": "07:00 PM"
        }
      ];
      int index = 0;
      _originCityController.text = dadosExemplo[index]["originCity"]!;
      _originNeighborhoodController.text = dadosExemplo[index]["originNeighborhood"]!;
      _originStreetController.text = dadosExemplo[index]["originStreet"]!;
      _originNumberController.text = dadosExemplo[index]["originNumber"]!;
      _destinationCityController.text = dadosExemplo[index]["destinationCity"]!;
      _destinationNeighborhoodController.text = dadosExemplo[index]["destinationNeighborhood"]!;
      _destinationStreetController.text = dadosExemplo[index]["destinationStreet"]!;
      _destinationNumberController.text = dadosExemplo[index]["destinationNumber"]!;
      _departureDateController.text = dadosExemplo[index]["departureDate"]!;
      _departureTimeController.text = dadosExemplo[index]["departureTime"]!;
    }
    _loadUserData();
    super.initState();
  }

  void _loadUserData() async {
    try {
      DocumentSnapshot? userData = await _fbServices.getUserData(widget.idUser, context);
      if (userData != null && userData.exists) {
        // Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;
        localUser = LocalUser.fromMap(userData.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Erro ao carregar os dados do usuário: $e');
    }
  }

  _createPublication() async {
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
      true,
      true,
      atualizationDate: DateTime.now().toString(),
    );
    if (!newPublication) {
      publication.registrationDate = publicationData.registrationDate;
      publication.idPublication = publicationData.idPublication;
    } else {
      publication.registrationDate = DateTime.now().toString();
    }
    try {
      if (!newPublication) {
        await _fbServices.savePublicationData(publication, context,
            atualization: publication.toMap());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Carona atualizada com sucesso!'),
        ));
      } else {
        await _fbServices.savePublicationData(
          publication,
          context,
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Carona criada com sucesso!'),
        ));
      }
    } catch (e) {
      print('Erro ao salvar as alterações: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erro ao salvar a postagem. Tente novamente mais tarde.'),
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Creação de Postagem")),
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
                  const SizedBox(width: 10),
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
              const Padding(
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
