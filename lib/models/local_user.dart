import 'package:proxima_parada_mobile/models/user_vehicle.dart';

// Classe que representa um usuáriolocal
class LocalUser {
  String? idUser; // ID do usuário
  String? name; // Nome do usuário
  String? phoneNumber; // Número de telefone do usuário
  String? imageLocation; // URL da imagem do usuário
  String? email; // Email do usuário
  bool isDriver = false; // Indica se o usuário é um motorista
  bool isRequestBeDriverOpen = false; // Indica se o usuário tem uma solicitação para ser passageiro aberta
  bool isRequestDenied = false; // Indica se a solicitação do usuário para ser passageiro foi negada
  UserVehicle? userVehicle; // Informações do veículo do usuário (se for um motorista)

  // Construtor da classe
  LocalUser(this.name, this.phoneNumber, this.email, this.userVehicle,
      [this.idUser, this.imageLocation]);

  //Construtor para criar um usuário vazio
  LocalUser.empty();

  // Construtor para criar um usuário a partir de um mapa (ex: dados do Firestore)
  LocalUser.fromMap(Map<String, dynamic> doc) {
    idUser = doc["idUser"];
    name = doc["name"];
    phoneNumber = doc["phone"];
    imageLocation = doc["imageLocation"];
    email = doc["email"];
    isDriver = doc["isDriver"];
    isRequestBeDriverOpen = doc["isRequestBeDriveOpen"];
    isRequestDenied = doc["isRequestDenied"];
    userVehicle = UserVehicle.fromMap(doc["userVehicle"]);
  }

  // Converte o usuário para um mapa (ex: para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      "idUser": idUser,
      "name": name,
      "phone": phoneNumber,
      "imageLocation": imageLocation,
      "email": email,
      "isDriver": isDriver,
      "isRequestBeDriveOpen": isRequestBeDriverOpen,
      "isRequestDenied": isRequestDenied,
      "userVehicle": userVehicle?.toMap(),
    };
  }

  // Setter para a URL da imagem do usuário
  set setLocationImage(String value) => imageLocation = value;
}