import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/create_post.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class MyRidesPage extends StatelessWidget {
  const MyRidesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              title: Text('Postagens minhas caronas $index'),
              subtitle: Text('Conteúdo da postagens minhas caronas $index'),
              onTap: () {
                print('Postagens minhas caronas $index selecionada!');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        onPressed: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePost())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
