import 'package:image_picker/image_picker.dart';
import 'package:proxima_parada_mobile/services/firebase_service.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  // Seleciona imagem da câmera ou galeria
  static Future<XFile?> selectImage({required bool fromCamera}) async {
    return await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    );
  }

  // Método para upload de imagem (a ser implementado de acordo com a lógica do Firebase)
  static Future<String?> uploadImage(String userId, String imagePath,
      {bool? isCar}) async {
    if (isCar != null) {
      return await FirebaseService.uploadImage(userId, imagePath, isCar: true);
    } else {
      return await FirebaseService.uploadImage(userId, imagePath);
    }
  }
}
