import 'package:cloud_firestore/cloud_firestore.dart';

class LocalUser {
  String? idUser;
  String? name;
  String? occupation;
  String? locationImage;
  String? email;

  LocalUser(this.idUser, this.name, this.occupation, this.email,
      [this.locationImage]);

  LocalUser.fromMap(QueryDocumentSnapshot doc) {
    idUser = doc["idUser"];
    name = doc["name"];
    occupation = doc["occupation"];
    locationImage = doc["locationImage"];
    email = doc["email"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": idUser,
      "name": name,
      "occupation": occupation,
      "locationImage": locationImage,
      "email": email,
    };
    return map;
  }

  set setLocationImage(String value) {
    locationImage = value;
  }
}
