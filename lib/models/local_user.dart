import 'package:proxima_parada_mobile/models/user_vehicler.dart';

class LocalUser {
  String? idUser;
  String? name;
  String? phoneNumber;
  String? imageLocation;
  String? email;
  bool isDriver = false;
  bool isRequestBeDriveOpen = false;
  bool isRequestDenied = false;
  UserVehicle? userVehicle;
  // Timestamp? createdAt;
  // Timestamp? updatedAt;

  LocalUser(this.name, this.phoneNumber, this.email, this.userVehicle,
      [this.idUser, this.imageLocation]);

  LocalUser.empty();

  LocalUser.fromMap(Map<String, dynamic> doc) {
    idUser = doc["idUser"];
    name = doc["name"];
    phoneNumber = doc["phone"];
    imageLocation = doc["imageLocation"];
    email = doc["email"];
    isDriver = doc["isDriver"];
    isRequestBeDriveOpen = doc["isRequestBeDriveOpen"];
    isRequestDenied = doc["isRequestDenied"];
    userVehicle = UserVehicle.fromMap(doc["userVehicle"]);
    // createdAt = doc["createdAt"];
    // updatedAt = doc["updatedAt"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": idUser,
      "name": name,
      "phone": phoneNumber,
      "imageLocation": imageLocation,
      "email": email,
      "isDriver": isDriver,
      "isRequestBeDriveOpen": isRequestBeDriveOpen,
      "isRequestDenied": isRequestDenied,
      "userVehicle": userVehicle?.toMap(),
      // "createdAt": createdAt,
      // "updatedAt": updatedAt,
    };
    return map;
  }

  set setLocationImage(String value) {
    imageLocation = value;
  }
}
