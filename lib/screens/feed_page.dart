import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/widget/loading_widget.dart';
import 'package:proxima_parada_mobile/widget/publication_card.dart';

class FeedPage extends StatelessWidget {
  FeedPage({Key? key}) : super(key: key);

  final FirebaseService _fbServices = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<QuerySnapshot>?>(
      future: _fbServices.getPublications(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CustomLoading(message: "Carregando publicações...");
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Text("Erro ao carregar dados!");
            }
            Stream<QuerySnapshot>? stream = snapshot.data;

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
                      return const Text("Erro ao carregar dados!");
                    }
                    QuerySnapshot? querySnapshot = snapshot.data;
                    if (querySnapshot!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nenhuma publicação! :( ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, index) {
                          List<DocumentSnapshot> publications = querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = publications[index];
                          Publication publication =
                              Publication.fromDocumentSnapshot(documentSnapshot);
                          return PublicationCard(publication: publication);
                        });
                }
              },
            );
        }
      },
    );
  }
}
