import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Publication {
  String? idUser;
  String idPublication = const Uuid().v6();
  String? userName;
  String? userPhoneNumber;
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
  String? updatedDate;

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
      this.statusPublication,
      this.vacancies,
      {this.registrationDate,
      this.updatedDate});

  Publication.fromMap(QueryDocumentSnapshot doc) {
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
    statusPublication = doc["statusPublication"];
    vacancies = doc["vacancies"];
    registrationDate = doc["registrationDate"];
    updatedDate = doc["updatedDate"];
  }

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
    statusPublication = doc["statusPublication"];
    vacancies = doc["vacancies"];
    registrationDate = doc["registrationDate"];
    updatedDate = doc["updatedDate"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "idUser": idUser,
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
      "statusPublication": statusPublication,
      "vacancies": vacancies,
      "registrationDate": registrationDate,
      "updatedDate": updatedDate,
    };
    return map;
  }
}
