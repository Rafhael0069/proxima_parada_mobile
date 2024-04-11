import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/welcome.dart';
import 'package:proxima_parada_mobile/screens/feed_page.dart';
import 'package:proxima_parada_mobile/screens/my_rides_page.dart';
import 'package:proxima_parada_mobile/screens/profile_page.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final bool _isRideVisible = true;

  // final FirebaseService _fbServices = FirebaseService();

  var currentUser = FirebaseAuth.instance.currentUser;

  // var currentUser =  _fbServices.getCurrentUser();

  late final List<Widget> _screens = _isRideVisible
      ? <Widget>[
          FeedPage(),
          MyRidesPage(
            idUser: currentUser!.uid,
          ),
          ProfilePage(
            userId: currentUser!.uid,
          ),
        ]
      : <Widget>[
          FeedPage(),
          ProfilePage(
            userId: currentUser!.uid,
          ),
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
        title: const Text("Próxima Parada"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                ShowAlertDialog.showAlertDialog(context, "Ainda não implementado :(");
              } else if (value == 'logout') {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Welcome()),
                    (Route<dynamic> route) => false);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sair'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.feed), label: "feed"),
          if (_isRideVisible)
            const BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "minhas caronas"),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: "perfil"),
        ],
      ),
    );
  }
}
