import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/components/configuracion.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:hnc/utils/visualizar_url.dart';
import 'package:hnc/widgets/contenido_story_compartido.dart';

import '../../repository/models/contenido.dart';

//import 'package:helpncare/componentes/un_contenido.dart';

class Compartido extends StatefulWidget {
  const Compartido({Key? key, required this.url}) : super(key: key);
  static const routeName = '/compartido';

  final String url;

  @override
  State<Compartido> createState() => _CompartidoState();
}

class _CompartidoState extends State<Compartido> {
  bool cargando = true;
  String? idContenido;
  Contenido? contenido;

  @override
  void initState() {
    idContenido =
        widget.url.substring(widget.url.indexOf('compartido?token=') + 17);
    super.initState();
  }

  Widget botonAcceder() {
    return SizedBox(
      width: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
          ),
          onPressed: () {
            lanzaURL(Environment().config!.baseUrlWeb);
          },
          child: const Text(
            'Acceder',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<HncRepository>();
    final carga = repo.getContenidoCompartido(idContenido!);
    carga.then((value) {
      contenido = value;
      setState(() {
        cargando = false;
      });
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 50,
          child: Image.asset('assets/images/helpncare_logo.png'),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: botonAcceder(),
          ),
        ],
      ),
      body: cargando
          ? const SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: ContenidoStoryCompartido(
              contenido: contenido!,
            )),
    );
  }
}
