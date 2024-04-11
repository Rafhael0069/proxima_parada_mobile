import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/models/publication.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _dbInstance = FirebaseFirestore.instance;
  final Reference _storageRef = FirebaseStorage.instance.ref();

  getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password, context) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        ShowAlertDialog.showAlertDialog(context, "E-mail inválido!");
      } else if (error.code == 'user-not-found') {
        ShowAlertDialog.showAlertDialog(
            context, "Não há registro de usuário existente correspondente ao e-mail fornecido.");
      } else if (error.code == 'wrong-password') {
        ShowAlertDialog.showAlertDialog(context, "Senha incorreta.");
      } else {
        ShowAlertDialog.showAlertDialog(context,
            "Ocorreu um erro ao acesser nossos servidores. por favor tente novamente mais tarde.");
      }
      return null;
    }
  }

  Future<Object?> createUserWithEmailAndPassword(
      LocalUser localUser, String password, context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: localUser.email!, password: password);
      localUser.idUser = userCredential.user!.uid;
      return localUser;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        ShowAlertDialog.showAlertDialog(context, "E-mail inválido.");
      } else if (error.code == 'email-already-in-use') {
        ShowAlertDialog.showAlertDialog(context, "Esse e-mail já está em uso por outro usiário.");
      } else if (error.code == 'weak-password') {
        ShowAlertDialog.showAlertDialog(
            context, "Sua senha é muito fraca. digite uma senha mais forte.");
      } else {
        ShowAlertDialog.showAlertDialog(context,
            "Ocorreu um erro ao acesser nossos servidores. por favor tente novamente mais tarde");
      }
      return null;
    }
  }

  Future<void> saveUserData(LocalUser localUser, BuildContext context) async {
    try {
      await _dbInstance.collection('users').doc(localUser.idUser).set(localUser.toMap());
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, "Erro: $e");
    }
  }

  Future<String?> uploadImage(LocalUser localUser, String pickedImage) async {
    try {
      String fileName = '${localUser.idUser}.jpg';
      SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );
      Reference fileRef = _storageRef.child("images/users/$fileName");
      UploadTask uploadTask = fileRef.putFile(File(pickedImage), metadata);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      if (taskSnapshot.state == TaskState.success) {
        final url = await taskSnapshot.ref.getDownloadURL();
        return url;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<DocumentSnapshot?> getUserData(String userId, BuildContext context) async {
    try {
      DocumentSnapshot documentSnapshot = await _dbInstance.collection('users').doc(userId).get();
      return documentSnapshot;
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, 'Erro ao obter os dados do usuário: $e');
      return null;
    }
  }

  Future<void> updateUserData(String userId, LocalUser localUser, BuildContext context) async {
    try {
      await _dbInstance.collection('users').doc(userId).update(localUser.toMap());
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, 'Erro ao atualizar os dados do usuário: $e');
    }
  }

  Future<void> savePublicationData(Publication publication, BuildContext context) async {
    try {
      DocumentReference docRef = await _dbInstance.collection('publications').add(publication.toMap());
      await docRef.update({'idPublication': docRef.id});
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, "Erro: $e");
    }
  }

  Future<Stream<QuerySnapshot>?> getPublications({String? idUser}) async {
    if (idUser != null) {
      try {
        Stream<QuerySnapshot> stream = FirebaseFirestore.instance
            .collection("publications")
            .where("idUser", isEqualTo: idUser)
            .orderBy("departureDate")
            .orderBy("departureTime")
            .snapshots();
        return stream;
      } catch (e) {
        print('Erro ao obter as publicações: $e');
        return null;
      }
    } else {
      try {
        Stream<QuerySnapshot> stream = FirebaseFirestore.instance
            .collection("publications")
            .where("statusPublication", isEqualTo: true)
            .where("vacancies", isEqualTo: true)
            .orderBy("departureDate")
            .orderBy("departureTime")
            .snapshots();
        return stream;
      } catch (e) {
        print('Erro ao obter as publicações: $e');
        return null;
      }
    }
  }
}
