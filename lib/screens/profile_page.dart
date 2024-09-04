import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proxima_parada_mobile/firebase/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/pages/create_and_edit_vehicle.dart';
import 'package:proxima_parada_mobile/pages/edit_profile_page.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';
import 'package:proxima_parada_mobile/widget/content_box.dart';
import 'package:proxima_parada_mobile/widget/user_starus_button.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  ProfilePage({super.key, required this.userId});

  final _phoneMask = MaskTextInputFormatter(
      mask: '(##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  void resquestBeDrive(BuildContext context) {
    ShowAlertDialog.showAlertDialog(
        context, "Desculpe, ainda não implementado :(");
  }

  @override
  Widget build(BuildContext context) {
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
          LocalUser userData =
              LocalUser.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ContentBox(
                        title: "Informações Pessoais",
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: userData.imageLocation != null
                                  ? CircleAvatar(
                                      radius: 150,
                                      backgroundImage:
                                          NetworkImage(userData.imageLocation!),
                                      backgroundColor: Colors.white,
                                    )
                                  : const CircleAvatar(
                                      radius: 150,
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
                                      _phoneMask
                                          .maskText(userData.phoneNumber!),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ElevatedButton(
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
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 6,
                    ),
                    ContentBox(
                        title: "Informações do veículo",
                        child: Column(
                          children: [
                            if (userData.userVehicle?.plate != null)
                              Column(
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        userData.userVehicle!.imageLocation!),
                                    width: 350,
                                    height: 350,
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Icon(
                                          Icons.directions_car,
                                          size: 50,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Marca",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                            userData.userVehicle!.brand!,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Icon(
                                          Icons.directions_car,
                                          size: 50,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Modelo",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                            userData.userVehicle!.model!,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Icon(
                                          Icons.color_lens,
                                          size: 50,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Cor",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                            userData.userVehicle!.color!,
                                            // Email do usuário
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Icon(
                                          Icons.pin,
                                          size: 50,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Placa",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Text(
                                            userData.userVehicle!.plate!,
                                            // Email do usuário
                                            style: const TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(45)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateAndEditVehicle(
                                                  userId: userId)));
                                  // ShowAlertDialog.showAlertDialog(context, "Desculpe, ainda não implementado :(");
                                },
                                child: Text(
                                    userData.userVehicle?.plate != null
                                        ? 'Editar veiculo'
                                        : 'Adicionar veículo',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                              ),
                            ),
                          ],
                        )),
                    if (userData.userVehicle?.plate != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        child: UserStatusButton(
                          isDriver: userData.isDriver,
                          isRequestBeDriveOpen: userData.isRequestBeDriveOpen,
                          isRequestDenied: userData.isRequestDenied,
                          onRequestBeDrive: () => resquestBeDrive(context),
                        ),
                      )
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
