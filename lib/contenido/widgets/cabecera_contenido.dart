import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:helpncare/bloc/session/session_bloc.dart';
import 'package:helpncare/components/configuracion.dart';
//import 'package:helpncare/editor/bloc/editor_bloc.dart';
//import 'package:helpncare/editor/views/editor.dart';
//import 'package:helpncare/repository/hnc_repository.dart';
import 'package:helpncare/tipos.dart';

import '../../components/dialog.dart';
//import '../../components/log.dart';
import '../../components/log.dart';
import '../../repository/models/contenido.dart';
//import '../bloc/contenido_bloc.dart';

@immutable
class CabeceraContenido extends StatelessWidget {
  const CabeceraContenido(
      {Key? key,
      required this.contenido,
      required this.eliminar,
      required this.editar,
      required this.compartir,
      required this.denunciar})
      : super(key: key);

  final TextStyle estiloUsuario =
      const TextStyle(color: Colors.black87, fontSize: 14);
  final TextStyle estiloPublico =
      const TextStyle(color: Colors.black45, fontSize: 14);
  final TextStyle estiloGrupo =
      const TextStyle(color: Colors.blue, fontSize: 14);

  final Contenido contenido;
  final CallbackContenidoAsync eliminar;
  final CallbackContenidoAsync editar;
  final CallbackContenidoAsync compartir;
  final CallbackContenidoAsync denunciar;

  @override
  Widget build(BuildContext context) {
    //print('cabecera: $_id $_usuario');
    return Container(
      margin: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundImage: NetworkImage(
              '${Environment().config!.baseUrlServicios}/data/avatarusuario?id=${contenido.avatar}',
            ),
            // AssetImage('assets/images/helpncare.jpg'),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  children: [
                    Text(
                      contenido.creador + ' ',
                      //_usuario + ' ',
                      style: estiloUsuario,
                      //,
                    ),
                    Text(
                      'publicó en el grupo ',
                      style: estiloPublico,
                    ),
                    Text(
                      contenido.categorias,
                      //_grupo,
                      style: estiloGrupo,
                    )
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      color: Colors.black38,
                      size: 14.0,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      contenido.cuando,
                      //_fecha,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          contenido.propietario
              ? IconButton(
                  onPressed: () async {
                    Dialogs.continuarCancelar(
                        context,
                        'Eliminar',
                        contenido.modo == 1
                            ? 'Eliminar contenido'
                            : 'Eliminar story',
                        contenido.modo == 1
                            ? '¿Seguro que quiere eliminar el contenido?'
                            : '¿Seguro que quiere eliminar la story?',
                        () async {
                      Log.registra('eliminar en cabecera: $contenido');
                      await eliminar(contenido);
                    });
                    //muestraDialogoEliminar(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (ctx) => NuevaStory(
                    //       modo: 2,
                    //       contenido: contenido,
                    //     ),
                    //   ),
                    // );
                  },
                  icon: const Icon(Icons.delete),
                  color: Theme.of(context).primaryColor,
                )
              : const SizedBox(
                  width: 0,
                ),
          contenido.propietario
              ? IconButton(
                  onPressed: () async {
                    await editar(contenido);
                    //Log.registra(contenido!.multimedia);
                  },
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                )
              : const SizedBox(
                  width: 0,
                ),
          Tooltip(
            message: 'Denunciar contenido',
            child: IconButton(
              onPressed: () async {
                Dialogs.continuarCancelar(
                    context,
                    'Denunciar',
                    'Denunciar contenido',
                    '¿Desea denunciar este contenido? ', () {
                  denunciar(contenido);
                });
              },
              icon: const Icon(Icons.security),
              color: Colors.red,
            ),
          ),
          Tooltip(
            message: 'Compartir',
            child: IconButton(
              onPressed: () async {
                Log.registra('Compartir');
                await compartir(contenido);
              },
              icon: const Icon(Icons.share),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
