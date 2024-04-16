class LocalUser {
  String? idUser;
  String? name;
  String? phoneNumber;
  String? locationImage;
  String? email;

  LocalUser(this.name, this.phoneNumber, this.email, [this.idUser, this.locationImage]);

  LocalUser.empty();

  LocalUser.fromMap(Map<String, dynamic> doc) {
    idUser = doc["idUser"];
    name = doc["name"];
    phoneNumber = doc["phone"];
    locationImage = doc["locationImage"];
    email = doc["email"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": idUser,
      "name": name,
      "phone": phoneNumber,
      "locationImage": locationImage,
      "email": email,
    };
    return map;
  }

  set setLocationImage(String value) {
    locationImage = value;
  }
}
