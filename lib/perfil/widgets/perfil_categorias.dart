import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/components/configuracion.dart';
import 'package:helpncare/repository/models/categoria.dart';
import 'package:helpncare/widgets/una_columna.dart';

import '../../components/log.dart';
import '../bloc/perfil_bloc.dart';

class PerfilCategorias extends StatelessWidget {
  const PerfilCategorias({Key? key}) : super(key: key);

  Widget _categoria(BuildContext context, Categoria categoria) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SwitchListTile(
          key: Key('C${categoria.id}'),
          title: Text(categoria.descripcion),
          value: categoria.seleccionada,
          onChanged: (bool value) {
            context
                .read<PerfilBloc>()
                .add(PerfilCategoriaCambiadaEvent(categoria: categoria));
          },
          secondary: Image.network(
              "${Environment().config!.baseUrlServicios}/data/avatarCategoria?id=${categoria.avatar}")
          //Image.memory(categoria.bytes()),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PerfilBloc, PerfilState>(
      builder: (context, state) {
        Log.registra(state.toString());
        return SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => UnaColumna(
                    child: SizedBox(
                      width: 400,
                      child: _categoria(context, state.categorias[index]),
                    ),
                  ),
              childCount: state.categorias.length),
        );
      },
    );
  }
}
