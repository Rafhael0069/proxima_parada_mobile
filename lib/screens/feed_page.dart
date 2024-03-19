import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListTile(
            title: Text('Postagens principais $index'),
            subtitle: Text('Conteúdo das postagens principais $index'),
            onTap: () {
              print('Postagens principais $index selecionada!');
            },
          ),
        );
      },
    );
  }
}
