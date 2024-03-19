import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> telas = [
      Text('feed'),
      Text('minhas caronas'),
      Text('perfil'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Próxima Parada"),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.menu))],
      ),
      body: telas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => {
          setState(() {
            _currentIndex = index;
          })
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "feed"),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "minhas caronas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "perfil"),
        ],
      ),
    );
  }
}
