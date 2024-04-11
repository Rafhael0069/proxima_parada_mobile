import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/models/publication.dart';

import '../utils/show_alert_dialog.dart';

class PublicationCard extends StatelessWidget {
  PublicationCard({required this.publication, this.idUser, Key? key}) : super(key: key);

  final Publication publication;
  final String? idUser;

  @override
  Widget build(BuildContext context) {
    return idUser != null
        ? Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                IntrinsicHeight(
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
                ),
                const Divider(
                  thickness: 2,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
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
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: OutlinedButton(
                          onPressed: publication.statusPublication!
                              ? () {
                                  // _showDialogRegistrationOrChangePublication(
                                  //     publication: publication);
                                  ShowAlertDialog.showAlertDialog(
                                      context, "Ainda não implementado :(");
                                }
                              : null,
                          style: publication.statusPublication!
                              ? OutlinedButton.styleFrom(
                                  side: const BorderSide(width: 2, color: Colors.green),
                                )
                              : OutlinedButton.styleFrom(
                                  side: const BorderSide(width: 2, color: Colors.grey),
                                ),
                          // child: Text("Cancelar", style: TextStyle(color: Colors.red),)
                          child: publication.statusPublication!
                              ? const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: OutlinedButton(
                          onPressed: publication.statusPublication!
                              ? () {
                                  // _displayDialogChangingStatus("V", publication);
                                  ShowAlertDialog.showAlertDialog(
                                      context, "Ainda não implementado :(");
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            side: publication.statusPublication!
                                ? publication.vacancies!
                                    ? const BorderSide(width: 2, color: Colors.yellow)
                                    : const BorderSide(width: 2, color: Colors.green)
                                : publication.vacancies!
                                    ? const BorderSide(width: 2, color: Colors.grey)
                                    : const BorderSide(width: 2, color: Colors.grey),
                          ),
                          child: publication.statusPublication!
                              ? publication.vacancies!
                                  ? const Icon(
                                      Icons.block,
                                      color: Colors.yellow,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 30,
                                    )
                              : publication.vacancies!
                                  ? const Icon(
                                      Icons.block,
                                      color: Colors.grey,
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4),
                        child: OutlinedButton(
                            onPressed: publication.statusPublication!
                                ? () {
                                    // _displayDialogChangingStatus("C", publication);
                                    ShowAlertDialog.showAlertDialog(
                                        context, "Ainda não implementado :(");
                                  }
                                : null,
                            style: OutlinedButton.styleFrom(
                              side: publication.statusPublication!
                                  ? const BorderSide(width: 2, color: Colors.red)
                                  : const BorderSide(width: 2, color: Colors.grey),
                            ),
                            child: publication.statusPublication!
                                ? const Icon(
                                    Icons.cancel,
                                    color: Colors.red,
                                    size: 30,
                                  )
                                : const Icon(
                                    Icons.cancel,
                                    color: Colors.grey,
                                    size: 30,
                                  )),
                      ),
                    ),
                  ],
                ), //Row actions
              ],
            ),
          )
        : Card(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              children: [
                Row(
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
                              ShowAlertDialog.showAlertDialog(context, "Ainda não implementado :(");
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
          );
  }
}
