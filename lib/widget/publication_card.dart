import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/pages/create_and_edit_post.dart';
import 'package:proxima_parada_mobile/widget/dialogs.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PublicationCard extends StatelessWidget {
  final Publication publication;
  final String? idUser;

  const PublicationCard({required this.publication, this.idUser, Key? key})
      : super(key: key);

  // Método para atualizar a publicação usando o serviço do Firebase
  void _updatePublication(Publication publication, BuildContext context,
      Map<String, Object> atualization) async {
    try {
      await FirebaseService.savePublicationData(publication, context,
          update: atualization);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Carona atualizada com sucesso!',
                style: TextStyle(fontSize: 16))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Erro ao salvar as alterações. Tente novamente mais tarde.',
                style: TextStyle(fontSize: 16))),
      );
    }
  }

  // Método para enviar mensagem no WhatsApp
  void sendMessageOnWhatsApp(BuildContext context, String phoneNumber, String message) async {
    String url = "whatsapp://send?phone=+55$phoneNumber&text=${Uri.encodeFull(message)}";
    await launchUrlString(url);
    // if (await canLaunchUrlString(url)) {
    //   await launchUrlString(url);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //         content: Text("Ocorreu um erro ao tentar abrir o WhatsApp",
    //             style: TextStyle(fontSize: 16))),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return idUser != null ? _buildUserCard(context) : _buildPublicCard(context);
  }

  // Método para construir o card do usuário logado
  Widget _buildUserCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          _buildAddressSection(
              "Origem",
              publication.originCity,
              publication.originNeighborhood,
              publication.originStreet,
              publication.originNumber),
          const VerticalDivider(thickness: 2, color: Colors.grey),
          _buildAddressSection(
              "Destino",
              publication.destinationCity,
              publication.destinationNeighborhood,
              publication.destinationStreet,
              publication.destinationNumber),
          const Divider(
              thickness: 2, color: Colors.grey, indent: 10, endIndent: 10),
          _buildDateTimeSection(),
          const Divider(
              thickness: 2, color: Colors.grey, indent: 10, endIndent: 10),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  // Método para construir o card de publicação
  Widget _buildPublicCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          _buildUserInfoSection(),
          const Divider(
              thickness: 2, color: Colors.grey, indent: 10, endIndent: 10),
          _buildAddressSection(
              "Origem",
              publication.originCity,
              publication.originNeighborhood,
              publication.originStreet,
              publication.originNumber),
          const VerticalDivider(thickness: 2, color: Colors.grey),
          _buildAddressSection(
              "Destino",
              publication.destinationCity,
              publication.destinationNeighborhood,
              publication.destinationStreet,
              publication.destinationNumber),
          const Divider(
              thickness: 2, color: Colors.grey, indent: 10, endIndent: 10),
          _buildDateTimeSection(),
          const Divider(
              thickness: 2, color: Colors.grey, indent: 10, endIndent: 10),
          _buildContactButton(context),
        ],
      ),
    );
  }

  // Método para construir as seções de endereço
  Widget _buildAddressSection(String title, String? city, String? neighborhood, String? street, String? number) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Cidade: $city", style: const TextStyle(fontSize: 16)),
                  Text("Bairro: $neighborhood",
                      style: const TextStyle(fontSize: 16)),
                  Text("Rua: $street", style: const TextStyle(fontSize: 16)),
                  Text("Nº: $number", style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir a seção de data e hora
  Widget _buildDateTimeSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Data da partida: ${publication.departureDate}",
              style: const TextStyle(fontSize: 16)),
          Text("Hora da partida: ${publication.departureTime}",
              style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback? onPressed,
    required bool isActive,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: isActive ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? activeColor : inactiveColor,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : Colors.grey,
            size: 30,
          ),
        ),
      ),
    );
  }

  // Método principal para construir os botões de ação
  Widget _buildActionButtons(BuildContext context) {
    bool isPublicationActive = publication.statusPublication ?? false;
    bool hasVacancies = publication.vacancies ?? false;

    return Row(
      children: [
        _buildActionButton(
          context: context,
          icon: Icons.edit,
          activeColor: Colors.blue,
          inactiveColor: Colors.grey,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateAndEditPost(
                  idUser: idUser!,
                  existentPublication: publication,
                ),
              ),
            );
          },
          isActive: isPublicationActive,
        ),
        _buildActionButton(
          context: context,
          icon: hasVacancies ? Icons.block : Icons.check,
          activeColor: hasVacancies ? Colors.yellow : Colors.green,
          inactiveColor: Colors.grey,
          onPressed: () {
            showAlertDialogChangingPublications(context, "V", publication, _updatePublication);
          },
          isActive: isPublicationActive,
        ),
        _buildActionButton(
          context: context,
          icon: Icons.cancel,
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          onPressed: () {
            showAlertDialogChangingPublications(context, "P", publication, _updatePublication);
          },
          isActive: isPublicationActive,
        ),
      ],
    );
  }

  // Método para construir o botão de contato
  Widget _buildContactButton(BuildContext context) {
    return Row(
      //Row actions
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: ElevatedButton.icon(
              onPressed: () => sendMessageOnWhatsApp(
                  context,
                  publication.userPhoneNumber!,
                  "Olá, tenho interesse na sua carona!"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              icon: const Icon(
                Icons.message,
                color: Colors.white,
              ),
              label: const Text(
                "Enviar mensagem",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Método para construir a seção de informações do usuário
  Widget _buildUserInfoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                publication.userName!,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(publication.userLocationImage!),
          ),
        )
      ],
    );
  }
}
