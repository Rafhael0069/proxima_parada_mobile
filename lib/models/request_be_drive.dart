import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:uuid/uuid.dart';

class RequestBeDrive {
  String idRequest = const Uuid().v6();
  LocalUser? localUser;
  bool statusRequest = false;
  bool readeRequest = false;
  String? statusDescriptionDenied;
  // DateTime createdAt = DateTime.now();
  // DateTime updatedAt = DateTime.now();

  RequestBeDrive(this.localUser);

  RequestBeDrive.fromMap(Map<String, dynamic> doc) {
    idRequest = doc["idRequisition"];
    localUser = LocalUser.fromMap(doc["localUser"]);
    statusRequest = doc["statusRequest"];
    readeRequest = doc["readeRequest"];
    statusDescriptionDenied = doc["statusDescriptionDenied"];
    // createdAt = doc["createdAt"];
    // updatedAt = doc["updatedAt"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idRequisition": idRequest,
      "localUser": localUser!.toMap(),
      "statusRequest": statusRequest,
      "readeRequest": readeRequest,
      "statusDescriptionDenied": statusDescriptionDenied,
      // "createdAt": createdAt,
      // "updatedAt": updatedAt,
    };
    return map;
  }
}
