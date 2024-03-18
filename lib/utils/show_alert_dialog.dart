import 'package:flutter/material.dart';

class ShowAlertDialog {
  static showAlertDialog(context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: AlertDialog(
                title: Text(message),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
