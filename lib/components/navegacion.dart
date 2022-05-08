import 'package:flutter/material.dart';

class Navegacion {
  void navegar(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    ).then((value) {
      Navigator.pop(context);
    });
  }
}
