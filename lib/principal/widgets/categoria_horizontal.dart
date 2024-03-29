import 'package:flutter/material.dart';

import '../../components/configuracion.dart';
import '../../repository/models/categoria.dart';

typedef CategoriaCambiada = Function(Categoria categoria);

class CategoriaHorizontal extends StatelessWidget {
  const CategoriaHorizontal(
      {Key? key,
      required this.categoria,
      required this.seleccionada,
      required this.callback})
      : super(key: key);

  final Categoria categoria;
  final bool seleccionada;
  final CategoriaCambiada callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile(
        title: Text(categoria.descripcion),
        value: seleccionada,
        onChanged: (bool value) {
          callback(categoria);
          //print("switch");
          //categoria.cambiaSeleccionada(context, categoria.id);
        },
        secondary: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.contain,
              image: Image.network(
                      "${Environment().config!.baseUrlServicios}/data/avatarCategoria?id=${categoria.avatar}")
                  .image,
            ),
          ),

          //Image.memory(categoria.bytes()),
        ),
      ),
    );
  }
}
