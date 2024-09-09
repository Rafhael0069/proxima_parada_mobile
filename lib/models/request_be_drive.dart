import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:uuid/uuid.dart';

// Classe que representa uma solicitação para ser passageiro
class RequestBeDrive {
  String idRequest = const Uuid().v6(); // ID da solicitação (gerado automaticamente)
  LocalUser? localUser; // Informações do usuário que fez a solicitação
  bool statusRequest = false; // Status da solicitação
  bool readeRequest = false; // Indica se a solicitação foi lida
  bool statusDescriptionDenied = false; // Indica se a descrição da solicitação foi recusada

  // Construtor da classe
  RequestBeDrive(this.localUser);

  // Construtor para criar uma solicitação a partir de um mapa (ex: dados do Firestore)
  RequestBeDrive.fromMap(Map<String, dynamic> doc) {
    idRequest = doc["idRequest"];
    localUser = LocalUser.fromMap(doc["localUser"]);
    statusRequest = doc["statusRequest"];
    readeRequest = doc["readeRequest"];
    statusDescriptionDenied = doc["statusDescriptionDenied"];
  }

  // Converte a solicitação para um mapa (ex: para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      "idRequest": idRequest,
      "localUser": localUser!.toMap(),
      "statusRequest": statusRequest,
      "readeRequest": readeRequest,
      "statusDescriptionDenied": statusDescriptionDenied,
    };
  }
}