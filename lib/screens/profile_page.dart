import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/pages/create_and_edit_vehicle.dart';
import 'package:proxima_parada_mobile/pages/edit_profile_page.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  ProfilePage({super.key, required this.userId});

  final _phoneMask = MaskTextInputFormatter(
      mask: '(##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return StreamBuilder(
      stream: FirebaseService.getUserStream(userId, context),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
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
          LocalUser userData =
              LocalUser.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          return SingleChildScrollView(
            child: Container(
              height: mediaQuery.size.height,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: userData.locationImage != null
                              ? CircleAvatar(
                                  radius: 100,
                                  backgroundImage:
                                      NetworkImage(userData.locationImage!),
                                  backgroundColor: Colors.white,
                                )
                              : const CircleAvatar(
                                  radius: 100,
                                  backgroundImage: AssetImage(
                                      'assets/images/user_avatar.png'),
                                  backgroundColor: Colors.white,
                                ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.perm_identity_outlined,
                                size: 50,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Nome",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  userData.name!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.phone_outlined,
                                size: 50,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Telefone",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  _phoneMask.maskText(userData.phoneNumber!),
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(
                                Icons.email_outlined,
                                size: 50,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Email",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  userData.email!, // Email do usuário
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(userId: userId)));
                      },
                      child: const Text('Editar Perfil',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CreateAndEditVehicle(userId: userId)));
                        // ShowAlertDialog.showAlertDialog(context, "Desculpe, ainda não implementado :(");
                      },
                      child: const Text('Adicionar veiculo',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45)),
                      onPressed: () {
                        ShowAlertDialog.showAlertDialog(
                            context, "Desculpe, ainda não implementado :(");
                      },
                      child: const Text('Quero oferecer caronas',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
