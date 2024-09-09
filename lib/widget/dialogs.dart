import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/models/publication.dart';

// Função para exibir o diálogo de confirmação de alteração de publicações
void showAlertDialogChangingPublications(BuildContext context, String type,
    Publication publication, Function updatePublication) {
  String textTitle = (type == "V")
      ? "Tem certeza que deseja encerrar as vagas desta carona?"
      : "Tem certeza que deseja cancelar esta carona?";

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
                          side: const BorderSide(
                              width: 2, color: Colors.redAccent),
                        ),
                        child: const Text(
                          "Não",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: OutlinedButton(
                        onPressed: () {
                          Map<String, Object> atualization;
                          if (type == "V") {
                            atualization = {
                              "vacancies": !publication.vacancies!,
                              "atualizationDate": DateTime.now().toString()
                            };
                          } else {
                            atualization = {
                              "statusPublication":
                                  !publication.statusPublication!,
                              "atualizationDate": DateTime.now().toString()
                            };
                          }
                          updatePublication(publication, context, atualization);
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              width: 2, color: Colors.blue),
                        ),
                        child: const Text(
                          "Sim",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
