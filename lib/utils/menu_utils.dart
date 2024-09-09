import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proxima_parada_mobile/pages/welcome.dart';
import 'package:proxima_parada_mobile/utils/show_alert_dialog.dart';

class MenuUtils {
  static void onMenuItemSelected(BuildContext context, String value) {
    if (value == 'settings') {
      ShowAlertDialog.showAlertDialog(context, "Ainda não implementado :(");
    } else if (value == 'logout') {
      FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Welcome()),
            (Route<dynamic> route) => false,
      );
    }
  }

  static List<PopupMenuEntry<String>> buildMenuItems() {
    return <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'settings',
        child: ListTile(
          leading: Icon(Icons.settings, color: Colors.blue,),
          title: Text('Configurações', style: TextStyle(color: Colors.blue),),
        ),
      ),
      const PopupMenuItem<String>(
        value: 'logout',
        child: ListTile(
          leading: Icon(Icons.exit_to_app, color: Colors.blue,),
          title: Text('Sair', style: TextStyle(color: Colors.blue),),
        ),
      ),
    ];
  }
}
