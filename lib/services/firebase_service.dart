// Importa as bibliotecas necessárias
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/models/request_be_drive.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

// Classe que encapsula os serviços do Firebase
class FirebaseService {
  // Instâncias estáticas dos serviços do Firebase
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;
  static final _storage = FirebaseStorage.instance.ref();// Retorna o usuário atual
  static User? getCurrentUser() => _auth.currentUser;

  // Faz login com email e senha
  static Future<User?> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, context); // Trata exceções de autenticação
      return null;
    }
  }

  // Cria um novo usuário com email e senha
  static Future<LocalUser?> createUserWithEmailAndPassword(LocalUser localUser, String password, BuildContext context) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: localUser.email!, password: password);
      localUser.idUser = userCredential.user!.uid;
      return localUser;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, context); // Trata exceções de autenticação
      return null;
    }
  }// Altera o email do usuário
  static Future<void> changeEmail(BuildContext context, String newEmail) async {
    try {
      await _auth.currentUser?.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e, context); // Trata exceções de autenticação
    }
  }

  // Altera a senha do usuário
  static Future<void> changePassword(String newPassword, BuildContext context) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      ShowAlertDialog.showAlertDialog(context, 'Erro ao alterar a senha: ${e.message}');
    }
  }

  // Salva os dados do usuário no Firestore
  static Future<void> saveUserData(LocalUser localUser, BuildContext context) async {
    try {
      await _db.collection('users').doc(localUser.idUser).set(localUser.toMap());
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, "Erro ao salvar dados do usuário: $e");
    }
  }

  // Atualiza os dados do usuário no Firestore
  static Future<void> updateUserData(String userId, LocalUser localUser, BuildContext context) async {
    try {
      await _db.collection('users').doc(userId).update(localUser.toMap());
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, 'Erro ao atualizar os dados do usuário: $e');
    }
  }

  // Faz upload de uma imagem para o Firebase Storage
  static Future<String?> uploadImage(String idUser, String pickedImage, {bool isCar = false}) async {
    try {
      final fileName = '$idUser${isCar ? 'carimage' : ''}.jpg';
      final fileRef = _storage.child("images/${isCar ? 'cars' : 'users'}/$fileName");
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final uploadTask = fileRef.putFile(File(pickedImage), metadata);
      final taskSnapshot = await uploadTask.whenComplete(() => null);
      return taskSnapshot.state == TaskState.success ?taskSnapshot.ref.getDownloadURL() : null;
    } catch (e) {
      return null;
    }
  }

  // Obtém os dados do usuário do Firestore
  static Future<DocumentSnapshot?> getUserData(String userId, BuildContext context) async {
    try {
      return await _db.collection('users').doc(userId).get();
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, 'Erro ao obter os dados do usuário: $e');
      return null;
    }
  }

  // Obtém um stream dos dados do usuário do Firestore
  static Stream<DocumentSnapshot>? getUserStream(String userId, BuildContext context) {
    try {
      return _db.collection('users').doc(userId).snapshots();
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, 'Erro ao obter stream do usuário: $e');
      return null;
    }
  }

  // Salva os dados de uma publicação no Firestore
  static Future<void> savePublicationData(Publication publication, BuildContext context, {Map<String, dynamic>? update}) async {
    try {
      if (update != null) {
        await _db.collection("publications").doc(publication.idPublication).update(update);
      } else {
        final docRef = await _db.collection('publications').add(publication.toMap());
        await docRef.update({'idPublication': docRef.id});
      }
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, "Erro ao salvar publicação: $e");
    }
  }

  // Obtém as publicações do Firestore (com filtro opcional por idUser)
  static Future<Stream<QuerySnapshot>?> getPublications({String? idUser}) async{
    if (idUser != null) {
      try {
        return _db.collection("publications")
            .where("idUser", isEqualTo: idUser)
            .orderBy("departureDate")
            .orderBy("departureTime")
            .snapshots();
      } catch (e) {
        print('Erro ao obter as publicações: $e');
        return null;
      }
    } else {
      try {
        return _db.collection("publications")
            .where("statusPublication", isEqualTo: true)
            .where("vacancies", isEqualTo: true)
            .where("departureDateTime", isGreaterThanOrEqualTo: Timestamp.now())
            .orderBy("departureDateTime")
            .snapshots();
      } catch (e) {
        print('Erro ao obter as publicações: $e');
        return null;
      }
    }
  }

  // Salva uma requisição para ser motorista no Firestore
  static Future<void> saveRequestBeDriver(RequestBeDrive requisition, BuildContext context) async {
    try {
      await _db.collection('requisitions').doc(requisition.idRequest).set(requisition.toMap());
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, "Erro ao salvar requisição: $e");
    }
  }

  // Trata exceções de autenticação do Firebase
  static void _handleAuthException(FirebaseAuthException e, BuildContext context) {
    switch (e.code) {
      case 'invalid-email':
        ShowAlertDialog.showAlertDialog(context, "E-mail inválido!");
        break;
      case 'user-not-found':
        ShowAlertDialog.showAlertDialog(context, "Usuário não encontrado.");
        break;
      case 'wrong-password':
        ShowAlertDialog.showAlertDialog(context, "Senha incorreta.");
        break;
      case 'email-already-in-use':
        ShowAlertDialog.showAlertDialog(context, "E-mail já em uso.");
        break;
      case 'weak-password':
        ShowAlertDialog.showAlertDialog(context, "Senha fraca.");
        break;
      default:
        ShowAlertDialog.showAlertDialog(context, "Erro de autenticação: ${e.message}");
    }
  }
}