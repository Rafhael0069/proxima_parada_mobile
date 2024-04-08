import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/utils/date_time_formator.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

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
                decoration:
                    const InputDecoration(labelText: "Cidade"),
              ),
              TextField(
                controller: _originNeighborhoodController,
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(labelText: "Bairro"),
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
                decoration:
                    const InputDecoration(labelText: "Numero"),
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
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "Destino",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              TextField(
                controller: _destinationCityController,
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(labelText: "Cidade"),
              ),
              TextField(
                controller: _destinationNeighborhoodController,
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(labelText: "Bairro"),
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
                decoration:
                    const InputDecoration(labelText: "Numero"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: ()=>{},
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45)),
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
