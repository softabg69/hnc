import 'package:flutter/material.dart';
import 'package:hnc/contenido/widgets/un_contenido.dart';
import 'package:hnc/repository/models/contenido.dart';

class Detalle extends StatelessWidget {
  const Detalle({Key? key, required this.contenido}) : super(key: key);

  final Contenido contenido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          contenido.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: UnContenido(contenido: contenido, esDetalle: true),
      ),
    );
  }
}
