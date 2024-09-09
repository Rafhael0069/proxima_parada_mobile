import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/widget/error_widget.dart';
import 'package:proxima_parada_mobile/widget/loading_widget.dart';
import 'package:proxima_parada_mobile/widget/publication_card.dart';

class FeedPage extends StatelessWidget {
  final String idUser;

  const FeedPage({Key? key, required this.idUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<QuerySnapshot>?>(
      future: FirebaseService.getPublications(),
      // Obtém o Stream de publicações
      builder: (context, snapshot) {
        // Exibe indicadores de carregamento ou erro conforme o estado da Future
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CustomLoading(message: "Carregando publicações...");
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const ErrorTextWidget(
                  message:
                      "Erro ao carregar dados!"); // Utiliza widget auxiliar para erros
            }
            Stream<QuerySnapshot>? stream = snapshot.data;
            return _buildPublicationsStreamBuilder(
                stream); // Construção do StreamBuilder separada
        }
      },
    );
  }

  // Constrói o StreamBuilder para as publicações
  Widget _buildPublicationsStreamBuilder(Stream<QuerySnapshot>? stream) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CustomLoading(message: "Carregando publicações...");
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const ErrorTextWidget(message: "Erro ao carregar dados!");
            }
            return _buildPublicationsList(
                snapshot); // Construção da lista de publicações separada
        }
      },
    );
  }

  // Constrói a lista de publicações ou exibe mensagem caso esteja vazia
  Widget _buildPublicationsList(AsyncSnapshot<QuerySnapshot?> snapshot) {
    if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
      return const Center(
        child: Text(
          "Nenhuma publicação! :( ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      );
    }

    // Converte os documentos em objetos de publicação e exibe em um ListView
    List<DocumentSnapshot> publications = snapshot.data!.docs.toList();
    return ListView.builder(
      itemCount: publications.length,
      itemBuilder: (_, index) {
        DocumentSnapshot documentSnapshot = publications[index];
        Publication publication =
            Publication.fromDocumentSnapshot(documentSnapshot);
        return PublicationCard(publication: publication);
      },
    );
  }
}
