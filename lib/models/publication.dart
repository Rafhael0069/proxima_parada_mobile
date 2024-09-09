import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

// Classe querepresenta uma publicação de carona
class Publication {
  String? idUser; // ID do usuário que criou a publicação
  String idPublication = const Uuid().v6(); // ID da publicação (gerado automaticamente)
  String? userName; // Nome do usuário
  String? userPhoneNumber;// Número de telefone do usuário
  String? userLocationImage; // URL da imagem do usuário
  String? originCity; // Cidade de origem
  String? originNeighborhood; // Bairro de origem
  String? originStreet; // Rua de origem
  String? originNumber; // Número do endereço de origem
  String? destinationCity; // Cidade de destino
  String? destinationNeighborhood; // Bairro de destino
  String? destinationStreet; // Rua de destino
  String? destinationNumber; // Número do endereço de destino
  String? departureDate; // Data de partida (formato string)
  String? departureTime; // Hora de partida (formato string)
  Timestamp? departureDateTime; // Data e hora de partida (Timestamp)
  bool? statusPublication; // Status da publicação (ativa/inativa)
  bool? vacancies; // Indica se há vagas disponíveis
  String? registrationDate; // Data de registro da publicação
  String? updatedDate; // Data da última atualização da publicação

  // Construtor da classe
  Publication(
      this.idUser,
      this.userName,
      this.userPhoneNumber,
      this.userLocationImage,
      this.originCity,
      this.originNeighborhood,
      this.originStreet,
      this.originNumber,
      this.destinationCity,
      this.destinationNeighborhood,
      this.destinationStreet,
      this.destinationNumber,
      this.departureDate,
      this.departureTime,
      this.departureDateTime,
      this.statusPublication,
      this.vacancies,
      {this.registrationDate,
        this.updatedDate});

  // Construtor para criar uma publicação a partir de um QueryDocumentSnapshot (Firestore)
  Publication.fromQueryDocumentSnapshot(QueryDocumentSnapshot doc) {
    idUser = doc["idUser"];
    idPublication = doc["idPublication"];
    userName = doc["userName"];
    userPhoneNumber = doc["userPhoneNumber"];
    userLocationImage = doc["userLocationImage"];
    originCity = doc["originCity"];
    originNeighborhood = doc["originNeighborhood"];
    originStreet = doc["originStreet"];
    originNumber = doc["originNumber"];
    destinationCity = doc["destinationCity"];
    destinationNeighborhood = doc["destinationNeighborhood"];
    destinationStreet = doc["destinationStreet"];
    destinationNumber = doc["destinationNumber"];
    departureDate = doc["departureDate"];
    departureTime = doc["departureTime"];
    departureDateTime = doc["departureDateTime"];
    statusPublication = doc["statusPublication"];
    vacancies = doc["vacancies"];
    registrationDate = doc["registrationDate"];
    updatedDate = doc["updatedDate"];
  }

  // Construtor para criar uma publicação a partir de um DocumentSnapshot (Firestore)
  Publication.fromDocumentSnapshot(DocumentSnapshot doc) {
    idUser = doc["idUser"];
    idPublication = doc["idPublication"];
    userName = doc["userName"];
    userPhoneNumber = doc["userPhoneNumber"];
    userLocationImage = doc["userLocationImage"];
    originCity = doc["originCity"];
    originNeighborhood = doc["originNeighborhood"];
    originStreet = doc["originStreet"];
    originNumber = doc["originNumber"];
    destinationCity = doc["destinationCity"];
    destinationNeighborhood = doc["destinationNeighborhood"];
    destinationStreet = doc["destinationStreet"];
    destinationNumber = doc["destinationNumber"];
    departureDate = doc["departureDate"];
    departureTime = doc["departureTime"];
    departureDateTime = doc["departureDateTime"];
    statusPublication = doc["statusPublication"];
    vacancies = doc["vacancies"];
    registrationDate = doc["registrationDate"];
    updatedDate = doc["updatedDate"];
  }

  // Converte a publicação para um mapa (ex: para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      "idUser": idUser,
      "idPublication": idPublication,
      "userName": userName,
      "userPhoneNumber": userPhoneNumber,
      "userLocationImage": userLocationImage,
      "originCity": originCity,
      "originNeighborhood": originNeighborhood,
      "originStreet": originStreet,
      "originNumber": originNumber,
      "destinationCity": destinationCity,
      "destinationNeighborhood": destinationNeighborhood,
      "destinationStreet": destinationStreet,
      "destinationNumber": destinationNumber,
      "departureDate": departureDate,
      "departureTime": departureTime,
      "departureDateTime": departureDateTime,
      "statusPublication": statusPublication,
      "vacancies": vacancies,
      "registrationDate": registrationDate,
      "updatedDate": updatedDate,
    };
  }
}