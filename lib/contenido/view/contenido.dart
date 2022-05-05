import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Contenido extends StatefulWidget {
  const Contenido({Key? key}) : super(key: key);

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: ((context, state) {}),
      child: Container(),
    );
  }
}
