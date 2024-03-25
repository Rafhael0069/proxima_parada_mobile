import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
          return Container(
            height: mediaQuery.size.height,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  userData.locationImage != null
                      ? CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(userData.locationImage!),
                    backgroundColor: Colors.white,
                  )
                      : const CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/user_avatar.png'),
                    backgroundColor: Colors.white,
                  ),
                  Text(
                    userData.name!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => EditProfilePage(userId: userId)));
                    },
                    child: const Text('Editar Perfil'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}