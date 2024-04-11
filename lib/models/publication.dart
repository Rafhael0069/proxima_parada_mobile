import 'package:cloud_firestore/cloud_firestore.dart';

class Publication {
  String? idUser;
  String? idPublication;
  String? userName;
  String? userOccupation;
  String? userLocationImage;
  String? originCity;
  String? originNeighborhood;
  String? originStreet;
  String? originNumber;
  String? destinationCity;
  String? destinationNeighborhood;
  String? destinationStreet;
  String? destinationNumber;
  String? departureDate;
  String? departureTime;
  bool? statusPublication;
  bool? vacancies;
  String? registrationDate;
  String? atualizationDate;

  Publication(
      this.idUser,
      this.userName,
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
      this.statusPublication,
      this.vacancies,
      {this.registrationDate,
      this.atualizationDate,
      this.idPublication});

  Publication.fromMap(QueryDocumentSnapshot doc) {
    idUser = doc["idUser"];
    idPublication = doc["idPublication"];
    userName = doc["userName"];
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
    statusPublication = doc["statusPublication"];
    vacancies = doc["vacancies"];
    registrationDate = doc["registrationDate"];
    atualizationDate = doc["atualizationDate"];
  }

  Publication.fromDocumentSnapshot(DocumentSnapshot doc) {
    idUser = doc["idUser"];
    idPublication = doc["idPublication"];
    userName = doc["userName"];
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
    statusPublication = doc["statusPublication"];
    vacancies = doc["vacancies"];
    registrationDate = doc["registrationDate"];
    atualizationDate = doc["atualizationDate"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": idUser,
      "userName": userName,
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
      "statusPublication": statusPublication,
      "vacancies": vacancies,
      "registrationDate": registrationDate,
      "atualizationDate": atualizationDate,
    };
    return map;
  }
}
