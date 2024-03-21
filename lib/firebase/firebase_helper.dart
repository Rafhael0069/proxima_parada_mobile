import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:proxima_parada_mobile/models/local_user.dart';

class FirebaseHelper {
  static get auth async => FirebaseAuth.instance;

  static get currentUser async => FirebaseAuth.instance.currentUser;

  static get dataBaseInstance async => FirebaseFirestore.instance;

  static get storageRef async => FirebaseStorage.instance.ref();

  static createUser(LocalUser localUser, String password) async {
    print("teste: Chegou no metodo create user");
    try {
      final user =
          await auth.createUserWithEmailAndPassword(email: localUser.email, password: password);
      localUser.idUser = user.user!.uid;
      await dataBaseInstance.collection("users").add(localUser.toMap()).then((value) {
        print("teste: Usuario criado com sucesso");
        return 1;
      }).catchError((error) {
        print("teste: erro: " + error);
        return error;
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        return "E-mail inválido.";
      } else if (error.code == 'email-already-in-use') {
        return "Esse e-mail já está em uso por outro usiário.";
      } else if (error.code == 'weak-password') {
        return "Sua senha é muito fraca. digite uma senha mais forte.";
      } else {
        return "Ocorreu um erro ao acesser nossos servidores. por favor tente novamente mais tarde";
      }
    }
  }

  saveUserData(LocalUser localUser) async {}
}
