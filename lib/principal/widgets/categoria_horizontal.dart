import 'package:flutter/material.dart';

import '../../components/configuracion.dart';
import '../../repository/models/categoria.dart';

typedef CategoriaCambiada = Function(Categoria categoria);

class CategoriaHorizontal extends StatelessWidget {
  const CategoriaHorizontal(
      {Key? key, required this.categoria, required this.callback})
      : super(key: key);

  final Categoria categoria;
  final CategoriaCambiada callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile(
        title: Text(categoria.descripcion),
        value: categoria.seleccionada,
        onChanged: (bool value) {
          callback(categoria);
          //print("switch");
          //categoria.cambiaSeleccionada(context, categoria.id);
        },
        secondary: Image.network(
            "${Environment().config!.baseUrlServicios}/data/avatarCategoria?id=${categoria.avatar}"),
      ),
    );
  }
}
