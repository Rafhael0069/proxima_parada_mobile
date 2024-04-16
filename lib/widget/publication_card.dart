import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/pages/create_and_edit_post.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PublicationCard extends StatelessWidget {
  PublicationCard({required this.publication, this.idUser, Key? key}) : super(key: key);

  final Publication publication;
  final String? idUser;
  final FirebaseService _fbServices = FirebaseService();

  _showAlertDialogChangingPublications(context, String type, Publication publication) {
    String textTitle = "";
    if (type == "V") {
      textTitle = "Tem certeza que deseja encerrar as vagas desta carona?";
    } else {
      textTitle = "Tem certeza que deseja cancelar esta carona?";
    }
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: AlertDialog(
                title: Text(textTitle),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 2, color: Colors.red),
                            ),
                            child: const Text(
                              "Não",
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: OutlinedButton(
                            onPressed: () async {
                              var atualization;
                              if (type == "V") {
                                if (publication.vacancies!) {
                                  atualization = {
                                    "vacancies": false,
                                    "atualizationDate": DateTime.now().toString()
                                  };
                                } else {
                                  atualization = {
                                    "vacancies": true,
                                    "atualizationDate": DateTime.now().toString()
                                  };
                                }
                                _updatePublication(publication, context, atualization);
                                Navigator.pop(context);
                              } else {
                                if (publication.statusPublication!) {
                                  atualization = {
                                    "statusPublication": false,
                                    "atualizationDate": DateTime.now().toString()
                                  };
                                } else {
                                  atualization = {
                                    "statusPublication": true,
                                    "atualizationDate": DateTime.now().toString()
                                  };
                                }
                                _updatePublication(publication, context, atualization);
                                Navigator.pop(context);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 2, color: Colors.blue),
                            ),
                            child: const Text(
                              "Sim",
                              style: TextStyle(fontSize: 16, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  _updatePublication(Publication publication, BuildContext context, var atualization) async {
    try {
      await _fbServices.savePublicationData(publication, context, atualization: atualization);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Carona atualizada com sucesso!'),
      ));
    } catch (e) {
      print('Erro ao salvar as alterações: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erro ao salvar as alterações. Tente novamente mais tarde.'),
      ));
    }
  }

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
                ),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateAndEditPost(
                                                idUser: idUser!,
                                                existentPublication: publication,
                                              )));
                                  // ShowAlertDialog.showAlertDialog(
                                  //     context, "Ainda não implementado :(");
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
                                  _showAlertDialogChangingPublications(context, "V", publication);
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
                                    _showAlertDialogChangingPublications(context, "C", publication);
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
                            onPressed: () => sendMessageOnWhatsApp(
                                context,
                                publication.userPhoneNumber!,
                                "Olá! Eu sou ${publication.userName}, estou entrando em contato por meio do aplicativo Próxima Parada, você pode conversar agora?"),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 2, color: Colors.blue),
                            ),
                            child: const Text(
                              "Conversar com o motorista.",
                              style: TextStyle(fontSize: 16, color: Colors.blue),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  void sendMessageOnWhatsApp(BuildContext context, String phoneNumber, String message) async {
    String url = "whatsapp://send?phone=+55$phoneNumber&text=${Uri.encodeFull(message)}";
    await launchUrlString(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ocorreu um erro ao tentar abrir o whatsApp")));
    }
  }
}
