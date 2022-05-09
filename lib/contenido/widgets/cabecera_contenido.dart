import 'package:flutter/material.dart';
import 'package:hnc/components/configuracion.dart';

import '../../components/dialog.dart';
import '../../repository/models/contenido.dart';

@immutable
class CabeceraContenido extends StatelessWidget {
  const CabeceraContenido({Key? key, this.contenido}) : super(key: key);
  //this._grupo, this._fecha, this._usuario, this._id, this._idCont);

  final TextStyle estiloUsuario =
      const TextStyle(color: Colors.black87, fontSize: 14);
  final TextStyle estiloPublico =
      const TextStyle(color: Colors.black45, fontSize: 14);
  final TextStyle estiloGrupo =
      const TextStyle(color: Colors.blue, fontSize: 14);

  final Contenido? contenido;
  // final String _grupo;
  // final String _fecha;
  // final String _usuario;
  // final int _id;
  // final String _idCont;

  // cardData.categorias,
  //                           cardData.fecha,
  //                           cardData.creador,
  //                           cardData.idCreador,
  //                           cardData.idContenido),

  // muestraDialogoEliminar(BuildContext context) {
  //   // set up the buttons
  //   Widget cancelButton = TextButton(
  //     child: const Text("Cancelar"),
  //     onPressed: () {
  //       Navigator.pop(context);
  //     },
  //   );
  //   Widget continueButton = TextButton(
  //     child: const Text("Eliminar"),
  //     onPressed: () {
  //       // Navigator.push(
  //       //   context,
  //       //   MaterialPageRoute(
  //       //     builder: (context) {
  //       //       EliminarContenido(idContenido: contenido!.idContenido),
  //       //     },
  //       //   ),
  //       // ).then((value) {
  //       //   Navigator.pop(context);
  //       // });
  //     },
  //   );
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: const Text("Eliminar contenido"),
  //     content: const Text("¿Seguro que quiere eliminar el contenido?"),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

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
              '${Environment().config!.baseUrlServicios}/data/avatarusuario?id=${contenido!.avatar}',
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
                      contenido!.creador + ' ',
                      //_usuario + ' ',
                      style: estiloUsuario,
                      //,
                    ),
                    Text(
                      'publicó en el grupo ',
                      style: estiloPublico,
                    ),
                    Text(
                      contenido!.categorias,
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
                      contenido!.cuando,
                      //_fecha,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
          contenido!.propietario
              ? IconButton(
                  onPressed: () async {
                    Dialogs.continuarCancelar(
                        context,
                        'Eliminar',
                        contenido!.modo == 1
                            ? 'Eliminar contenido'
                            : 'Eliminar story',
                        contenido!.modo == 1
                            ? '¿Seguro que quiere eliminar el contenido?'
                            : '¿Seguro que quiere eliminar la story?',
                        () {});
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
          contenido!.propietario
              ? IconButton(
                  onPressed: () async {
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
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).primaryColor,
                )
              : const SizedBox(
                  width: 0,
                ),
          IconButton(
            onPressed: () async {
              // await Share.share(
              //   '$kUrlApp/#/compartido?token=${contenido!.idContenido}',
              //   subject:
              //       '$email ha compartido contigo un contenido de helpncare',
              // );
            },
            icon: const Icon(Icons.share),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
