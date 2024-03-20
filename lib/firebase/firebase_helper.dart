import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper{

  static get auth async => FirebaseAuth.instance;

  static get currentUser async => FirebaseAuth.instance.currentUser;

  static get dataBaseInstance async => FirebaseFirestore.instance;

  static get storageRef async => FirebaseStorage.instance.ref();
}