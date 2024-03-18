import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Exit {
  bool isExitToDoubleTouch(bool isExitWarning){
    if (isExitWarning) {
      const messgeToast = 'Pressione voltar novamente para sair.';
      Fluttertoast.showToast(
          msg: messgeToast,
          fontSize: 18,
          backgroundColor: Colors.grey,
          textColor: Colors.black);
      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
  }
}