import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/models/publication.dart';

import '../utils/show_alert_dialog.dart';

class PublicationCard extends StatelessWidget {
  const PublicationCard({required this.publication, Key? key}) : super(key: key);

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 10),
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "De: ${publication.originNeighborhood} - ${publication.originCity}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Para: ${publication.destinationNeighborhood} - ${publication.destinationCity}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        children: [
          Column(
            children: [
              Row(
                // Row user data
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 10),
                        child: Text(
                          publication.userName!,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(publication.userLocationImage!),
                    ),
                  )
                ],
              ), //Row user data
              const Divider(
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              IntrinsicHeight(
                //Row adresses data
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 4, right: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Origem",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Cidade: ${publication.originCity}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Bairro: ${publication.originNeighborhood}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Rua: ${publication.originStreet}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Nº: ${publication.originNumber}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                    const VerticalDivider(
                      thickness: 2,
                      indent: 0,
                      endIndent: 0,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 4, top: 4, right: 10, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Destino",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Cidade: ${publication.destinationCity}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Bairro: ${publication.destinationNeighborhood}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Rua: ${publication.destinationStreet}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Nº: ${publication.destinationNumber}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ), //Row adresses data
              const Divider(
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              Row(
                //Row dateTime data
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data da partida: ${publication.departureDate}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Hora da partida: ${publication.departureTime}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ), //Row dateTime data
              const Divider(
                thickness: 2,
                indent: 10,
                endIndent: 10,
              ),
              Row(
                //Row actions
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: OutlinedButton(
                          onPressed: () {
                            ShowAlertDialog.showAlertDialog(context,"Ainda não implementado :(");
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(width: 2, color: Colors.blue),
                          ),
                          // child: Text("Cancelar", style: TextStyle(color: Colors.red),)
                          child: const Text(
                            "Conversar com o motorista.",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          )),
                    ),
                  ),
                ],
              ), //Row actions
            ],
          ),
        ],
      ),
    );
  }
}
