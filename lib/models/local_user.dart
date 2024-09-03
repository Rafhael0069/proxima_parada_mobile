import 'package:proxima_parada_mobile/models/user_vehicler.dart';

class LocalUser {
  String? idUser;
  String? name;
  String? phoneNumber;
  String? imageLocation;
  String? email;
  UserVehicle? userVehicle;

  LocalUser(this.name, this.phoneNumber, this.email, this.userVehicle, [this.idUser, this.imageLocation]);

  LocalUser.empty();

  LocalUser.fromMap(Map<String, dynamic> doc) {
    idUser = doc["idUser"];
    name = doc["name"];
    phoneNumber = doc["phone"];
    imageLocation = doc["imageLocation"];
    email = doc["email"];
    userVehicle = UserVehicle.fromMap(doc["userVehicle"]);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": idUser,
      "name": name,
      "phone": phoneNumber,
      "imageLocation": imageLocation,
      "email": email,
      "userVehicle": userVehicle?.toMap(),
    };
    return map;
  }

  set setLocationImage(String value) {
    imageLocation = value;
  }
}
