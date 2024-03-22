import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseService().getUserData(userId, context),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Erro ao carregar os dados do usuário'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text('Nenhum dado encontrado para este usuário'),
          );
        } else {
          // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          LocalUser userData = LocalUser.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                userData.locationImage != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(userData.locationImage!),
                        backgroundColor: Colors.white,
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/user_avatar.png'),
                        backgroundColor: Colors.white,
                      ),
                const SizedBox(height: 20),
                Text(
                  userData.name!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email: ${userData.email!}', // Email do usuário
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Ação quando o botão for pressionado (ex: editar perfil)
                  },
                  child: const Text('Editar Perfil'),
                ),
              ],
            ),
          );
          // Agora você pode usar os dados do usuário para construir a interface
          // return Scaffold(
          //   appBar: AppBar(
          //     title: Text('Perfil de ${userData['name']}'),
          //   ),
          //   body: Center(
          //     child: Text('Email: ${userData['email']}'),
          //   ),
          // );
        }
      },
    );
  }
}

/*
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseServices _fbServices = FirebaseServices();
  final currentUser = FirebaseServices.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   future: _fbServices.getUserData(currentUser , context),
    //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     } else if (snapshot.hasError) {
    //       return Center(
    //         child: Text('Erro ao carregar os dados do usuário'),
    //       );
    //     } else if (!snapshot.hasData || snapshot.data == null) {
    //       return Center(
    //         child: Text('Nenhum dado encontrado para este usuário'),
    //       );
    //     } else {
    //       Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
    //       // Agora você pode usar os dados do usuário para construir a interface
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: Text('Perfil de ${userData['name']}'),
    //         ),
    //         body: Center(
    //           child: Text('Email: ${userData['email']}'),
    //         ),
    //       );
    //     }
    //   },
    // );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/user_avatar.png'),
            backgroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          Text(
            'Nome do Usuário',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'email@exemplo.com', // Email do usuário
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Ação quando o botão for pressionado (ex: editar perfil)
            },
            child: Text('Editar Perfil'),
          ),
        ],
      ),
    );
  }
}

 */
