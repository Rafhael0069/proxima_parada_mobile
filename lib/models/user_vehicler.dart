class UserVehicle {
  String? brand;
  String? color;
  String? imageLocation;
  String? plate;
  String? model;

  UserVehicle([this.brand, this.color, this.imageLocation, this.plate, this.model]);

  UserVehicle.empty();

  UserVehicle.fromMap(Map<String, dynamic> doc) {
    brand = doc["brand"];
    color = doc["color"];
    imageLocation = doc["imageLocation"];
    plate = doc["plate"];
    model = doc["model"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "brand": brand,
      "color": color,
      "imageLocation": imageLocation,
      "plate": plate,
      "model": model,
    };
    return map;
  }

  set setLocationImage(String value) {
    imageLocation = value;
  }
}
