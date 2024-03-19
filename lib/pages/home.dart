import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/screens/feed_page.dart';
import 'package:proxima_parada_mobile/screens/my_rides_page.dart';
import 'package:proxima_parada_mobile/screens/profile_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _telas = <Widget>[
    FeedPage(),
    MyRidesPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Próxima Parada"),
        actions: [IconButton(onPressed: () => {}, icon: Icon(Icons.menu))],
      ),
      body: Center(
        child: _telas.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: "feed"),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "minhas caronas"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "perfil"),
        ],
      ),
    );
  }
}
