import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/request_be_drive.dart';
import 'package:proxima_parada_mobile/pages/create_and_edit_vehicle.dart';
import 'package:proxima_parada_mobile/pages/edit_profile_page.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';
import 'package:proxima_parada_mobile/widget/content_box.dart';
import 'package:proxima_parada_mobile/widget/custom_button.dart';
import 'package:proxima_parada_mobile/widget/error_widget.dart';
import 'package:proxima_parada_mobile/widget/user_status_button.dart';

class ProfilePage extends StatefulWidget {
  final String idUser;

  const ProfilePage({super.key, required this.idUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _phoneMask = MaskTextInputFormatter(
      mask: '(##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  bool _loading = false;

  // Função para solicitar status de motorista
  Future<void> requestBeDrive(LocalUser userData, BuildContext context) async {
    setState(() {
      _loading = true;
    });

    userData.isRequestBeDriverOpen = true;
    await FirebaseService.updateUserData(widget.idUser, userData, context);

    RequestBeDrive requestBeDrive = RequestBeDrive(userData);
    await FirebaseService.saveRequestBeDriver(requestBeDrive, context);

    setState(() {
      _loading = false;
    });

    ShowAlertDialog.showAlertDialog(
        context, "Sua solicitação foi encaminhada.");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseService.getUserStream(widget.idUser, context),
      // Obtém stream de dados do usuário
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); // Mostra indicador de carregamento
        } else if (snapshot.hasError) {
          return const ErrorTextWidget(
              message:
                  'Erro ao carregar os dados do usuário'); // Utiliza widget auxiliar para erros
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const ErrorTextWidget(
              message:
                  'Nenhum dado encontrado para este usuário'); // Mensagem quando não há dados
        } else {
          LocalUser userData = LocalUser.fromMap(snapshot.data!.data()
              as Map<String, dynamic>); // Converte snapshot para LocalUser
          return _buildProfileContent(
              userData); // Função separada para construir o conteúdo do perfil
        }
      },
    );
  }

  // Função que constrói o conteúdo do perfil
  Widget _buildProfileContent(LocalUser userData) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildPersonalInfoSection(userData),
              // Secção de informações pessoais
              const SizedBox(height: 6),
              _buildVehicleInfoSection(userData),
              // Secção de informações do veículo
              if (userData.userVehicle?.plate != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: UserStatusButton(
                    loading: _loading,
                    isDriver: userData.isDriver,
                    isRequestBeDriveOpen: userData.isRequestBeDriverOpen,
                    isRequestDenied: userData.isRequestDenied,
                    onRequestBeDrive: () => requestBeDrive(userData,
                        context), // Chama a função de solicitação para motorista
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir a seção de informações pessoais
  Widget _buildPersonalInfoSection(LocalUser userData) {
    return ContentBox(
      title: "Informações Pessoais",
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CircleAvatar(
              radius: 75,
              backgroundImage: userData.imageLocation != null
                  ? NetworkImage(userData.imageLocation!)
                  : const AssetImage('assets/images/user_avatar.png')
                      as ImageProvider,
              backgroundColor: Colors.white,
            ),
          ),
          _buildUserInfoRow(
            icon: Icons.perm_identity_outlined,
            label: "Nome",
            value: userData.name!,
          ),
          _buildUserInfoRow(
            icon: Icons.phone_outlined,
            label: "Telefone",
            value: _phoneMask.maskText(userData.phoneNumber!),
          ),
          _buildUserInfoRow(
            icon: Icons.email_outlined,
            label: "Email",
            value: userData.email!,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: CustomButton(
              text: "Editar Perfil",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfilePage(userId: widget.idUser),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função para construir a seção de informações do veículo
  Widget _buildVehicleInfoSection(LocalUser userData) {
    return ContentBox(
      title: "Informações do veículo",
      child: Column(
        children: [
          if (userData.userVehicle?.plate != null)
            _buildVehicleDetails(
                userData), // Mostra detalhes do veículo se existir
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: CustomButton(
              text: userData.userVehicle?.plate != null
                  ? 'Editar veículo'
                  : 'Adicionar veículo',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateAndEditVehicle(userId: widget.idUser),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função para construir os detalhes do veículo
  Widget _buildVehicleDetails(LocalUser userData) {
    return Column(
      children: [
        Image.network(
          userData.userVehicle!.imageLocation!,
          width: 350,
          height: 350,
        ),
        _buildVehicleInfoRow(
          icon: Icons.directions_car,
          label: "Marca",
          value: userData.userVehicle!.brand!,
        ),
        _buildVehicleInfoRow(
          icon: Icons.directions_car,
          label: "Modelo",
          value: userData.userVehicle!.model!,
        ),
        _buildVehicleInfoRow(
          icon: Icons.color_lens,
          label: "Cor",
          value: userData.userVehicle!.color!,
        ),
        _buildVehicleInfoRow(
          icon: Icons.pin,
          label: "Placa",
          value: userData.userVehicle!.plate!,
        ),
      ],
    );
  }

  // Função para construir uma linha de informações do usuário
  Widget _buildUserInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Função para construir uma linha de informações do veículo
  Widget _buildVehicleInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Icon(icon, size: 30, color: Colors.blue),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
