// Classe que representa o veículo de um usuário
class UserVehicle {
  String? brand; // Marca do veículo
  String? color; // Cor do veículo
  String? imageLocation; // URL da imagem do veículo
  String? plate; // Placa do veículo
  String? model; // Modelo do veículo

  // Construtor da classe
  UserVehicle([this.brand, this.color, this.imageLocation, this.plate, this.model]);

  // Construtor para criar um veículo vazio
  UserVehicle.empty();

  // Construtor para criar um veículo a partir de um mapa (ex: dados do Firestore)
  UserVehicle.fromMap(Map<String, dynamic> doc) {
    brand = doc["brand"];
    color = doc["color"];
    imageLocation = doc["imageLocation"];
    plate = doc["plate"];
    model = doc["model"];
  }

  // Converte o veículo para um mapa (ex: para salvar noFirestore)
  Map<String, dynamic> toMap() {
    return {
      "brand": brand,
      "color": color,
      "imageLocation": imageLocation,
      "plate": plate,
      "model": model,
    };
  }

  // Setter para a URL da imagem do veículo
  set setLocationImage(String value) => imageLocation = value;
}