import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> informacion(
      BuildContext context, Widget titulo, Widget cuerpo) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: titulo,
          content: cuerpo,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Ok'),
            )
          ],
        );
      },
    );
  }

  static void snackBar(
      {required BuildContext context,
      required Widget content,
      Color? color = Colors.red,
      Future<bool>? callback}) {
    final snackBar = SnackBar(
      content: callback != null
          ? WillPopScope(child: content, onWillPop: () => callback)
          : content,
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
