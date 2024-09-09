import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/pages/create_and_edit_post.dart';
import 'package:proxima_parada_mobile/widget/error_widget.dart';
import 'package:proxima_parada_mobile/widget/loading_widget.dart';
import 'package:proxima_parada_mobile/widget/publication_card.dart';

class MyRidesPage extends StatelessWidget {
  final String idUser;

  const MyRidesPage({super.key, required this.idUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Stream<QuerySnapshot>?>(
        future: FirebaseService.getPublications(idUser: idUser), // Chamada do serviço para obter publicações
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CustomLoading(message: "Carregando publicações..."); // Exibe carregamento
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return const ErrorTextWidget(message: "Erro ao carregar dados!"); // Utiliza widget auxiliar para erros
              }
              Stream<QuerySnapshot>? stream = snapshot.data;
              return _buildPublicationsStreamBuilder(stream); // Uso de função separada para StreamBuilder
          }
        },
      ),
      floatingActionButton: _buildFloatingActionButton(context), // Uso de função separada para o FAB
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
            return const CustomLoading(message: "Carregando publicações..."); // Exibe carregamento
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const ErrorTextWidget(message: "Erro ao carregar dados!"); // Utiliza widget auxiliar para erros
            }
            return _buildPublicationsList(snapshot); // Uso de função separada para a lista de publicações
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
        Publication publication = Publication.fromDocumentSnapshot(documentSnapshot);
        return PublicationCard(
          publication: publication,
          idUser: idUser,
        );
      },
    );
  }

  // Constrói o botão flutuante para adicionar novas publicações
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      onPressed: () => _navigateToCreatePost(context),
      child: const Icon(Icons.add),
    );
  }

  // Navega para a página de criação/edição de postagens
  void _navigateToCreatePost(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAndEditPost(
          idUser: idUser,
        ),
      ),
    );
  }
}
