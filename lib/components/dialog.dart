import 'package:flutter/material.dart';
import 'package:hnc/components/log.dart';
import 'package:http/retry.dart';
import 'package:image_picker/image_picker.dart';

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

  static void continuarCancelar(BuildContext context, String boton,
      String titulo, String mensaje, Function? callback) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancelar"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(boton),
      onPressed: () {
        Navigator.pop(context);
        if (callback != null) callback();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Future<ImageSource> selectorCamaraGaleria(BuildContext context) async {
    ImageSource res = ImageSource.camera;
    AlertDialog alert = AlertDialog(
      title: const Text('Seleccione origen'),
      content: const SizedBox(height: 0),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, ImageSource.camera);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.camera),
              SizedBox(
                width: 10,
              ),
              Text('Cámara'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, ImageSource.gallery);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.image),
              SizedBox(
                width: 10,
              ),
              Text('Galería'),
            ],
          ),
        )
      ],
    );
    // show the dialog
    await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    ).then((value) => res = value!);
    return res;
  }
}
