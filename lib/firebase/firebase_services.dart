import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class FirebaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _dbInstance = FirebaseFirestore.instance;

  static get currentUser async => FirebaseAuth.instance.currentUser;


  static get storageRef async => FirebaseStorage.instance.ref();

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

  Future<void> saveUserData(LocalUser localUser, context) async {
    try {
      await _dbInstance.collection('users').doc(localUser.idUser).set(localUser.toMap());
    } catch (e) {
      ShowAlertDialog.showAlertDialog(context, "Erro: $e");
    }
  }
}
