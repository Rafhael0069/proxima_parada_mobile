import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Exit {
  DateTime? _lastPressed;

  bool isExitToDoubleTouch(bool isExitWarning){

    if (isExitWarning) {
      if (_lastPressed == null || DateTime.now().difference(_lastPressed!) > const Duration(seconds: 2)) {
        _lastPressed = DateTime.now();
        const messageToast = 'Pressione voltar novamente para sair.';
        Fluttertoast.showToast(
            msg: messageToast,
            fontSize: 18,
            backgroundColor: Colors.grey,
            textColor: Colors.black);
        return false;
      } else {
        return true;
      }
    } else {
      Fluttertoast.cancel();
      return true;
    }

    // if (isExitWarning) {
    //   const messgeToast = 'Pressione voltar novamente para sair.';
    //   Fluttertoast.showToast(
    //       msg: messgeToast,
    //       fontSize: 18,
    //       backgroundColor: Colors.grey,
    //       textColor: Colors.black);
    //   return false;
    // } else {
    //   Fluttertoast.cancel();
    //   return true;
    // }
  }
}