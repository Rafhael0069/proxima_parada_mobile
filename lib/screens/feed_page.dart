import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/widget/publication_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  final FirebaseService _fbServices = FirebaseService();

  // Future<Stream<QuerySnapshot>?> _getAllPublications() async {
  //   Stream<QuerySnapshot> stream = FirebaseFirestore.instance
  //       .collection("publications")
  //       .where("statusPublication", isEqualTo: true)
  //       .where("vacancies", isEqualTo: true)
  //       .orderBy("departureDate")
  //       .orderBy("departureTime")
  //       .snapshots();
  //   stream.listen((dados) {
  //     _controller.add(dados);
  //   });
  //   return null;
  // }

  @override
  void initState() {
    // _getAllPublications();
    super.initState();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime timeBackPressed = DateTime.now();
    var carregandoDados = const Center(
      child: Column(
        children: [Text("Carregando publicações..."), CircularProgressIndicator()],
      ),
    );

    return FutureBuilder<Stream<QuerySnapshot>?>(
      future: _fbServices.getAllPublications(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return carregandoDados;
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
                    return carregandoDados;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return const Text("Erro ao carregar dados!");
                    }
                    QuerySnapshot? querySnapshot = snapshot.data;
                    if (querySnapshot!.docs.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(25),
                        child: const Text(
                          "Nenhuma publicação! :( ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }

                    return Expanded(
                        child: ListView.builder(
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (_, index) {
                              List<DocumentSnapshot> publications = querySnapshot.docs.toList();
                              DocumentSnapshot documentSnapshot = publications[index];
                              Publication publication =
                                  Publication.fromDocumentSnapshot(documentSnapshot);
                              return PublicationCard(publication: publication);
                            }));
                }
              },
            );
        }
      },
    );
  }
}
