import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/screens/feed_page.dart';
import 'package:proxima_parada_mobile/screens/my_rides_page.dart';
import 'package:proxima_parada_mobile/screens/profile_page.dart';
import 'package:proxima_parada_mobile/utils/menu_utils.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool _isRideVisible = false;
  var currentUser = FirebaseAuth.instance.currentUser;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
    _loadUserData();
  }

  // Inicializa a lista de telas com base no estado de visibilidade de rides
  void _initializeScreens() {
    _screens = [
      FeedPage(idUser: currentUser!.uid),
      ProfilePage(idUser: currentUser!.uid),
    ];
  }

  // Carrega os dados do usuário e atualiza a visibilidade de rides
  void _loadUserData() async {
    try {
      DocumentSnapshot? userData =
      await FirebaseService.getUserData(currentUser!.uid, context);
      if (userData != null && userData.exists) {
        LocalUser localUser = LocalUser.fromMap(userData.data() as Map<String, dynamic>);
        setState(() {
          _isRideVisible = localUser.isDriver;
          _screens = _isRideVisible
              ? <Widget>[
            FeedPage(idUser: currentUser!.uid),
            MyRidesPage(idUser: currentUser!.uid),
            ProfilePage(idUser: currentUser!.uid),
          ]
              : <Widget>[
            FeedPage(idUser: currentUser!.uid),
            ProfilePage(idUser: currentUser!.uid),
          ];
        });
      }
    } catch (e) {
      // print('Erro ao carregar os dados do usuário: $e');
    }
  }

  // Atualiza o índice selecionado no BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Próxima Parada",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) => MenuUtils.onMenuItemSelected(context, value),
            itemBuilder: (BuildContext context) => MenuUtils.buildMenuItems(),
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
          const BottomNavigationBarItem(
            icon: Icon(Icons.feed, size: 24, color: Colors.blue),
            label: "Feed",
          ),
          if (_isRideVisible)
            const BottomNavigationBarItem(
              icon: Icon(Icons.post_add, size: 24, color: Colors.blue),
              label: "Minhas Caronas",
            ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24, color: Colors.blue),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}