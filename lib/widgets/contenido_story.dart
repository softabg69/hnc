import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hnc/contenido/widgets/cabecera_contenido.dart';
import 'package:hnc/tipos.dart';
import 'package:hnc/widgets/una_columna.dart';

import '../components/configuracion.dart';
import '../repository/models/contenido.dart';

class ContenidoStory extends StatelessWidget {
  const ContenidoStory(
      {Key? key,
      required this.contenido,
      this.esDetalle = false,
      required this.onClick,
      required this.eliminar,
      required this.editar,
      required this.compartir,
      required this.cambiarGusta,
      required this.gustaCambiando})
      : super(key: key);

  final Contenido contenido;
  final bool esDetalle;
  final CallbackContenido onClick;
  final CallbackContenido eliminar;
  final CallbackContenido editar;
  final CallbackContenido compartir;
  final CallbackContenido cambiarGusta;
  final bool gustaCambiando;

  Widget imagen(BuildContext context) {
    return esDetalle
        ? InteractiveViewer(
            maxScale: kIsWeb ? 1 : 5,
            child: Image.network(
              '${Environment().config!.baseUrlServicios}/data/imagen?id=${contenido.multimedia}',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          )
        : AspectRatio(
            aspectRatio: 4 / 3,
            child: Image.network(
              '${Environment().config!.baseUrlServicios}/data/imagen?id=${contenido.multimedia}',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          );
  }

  Widget _gusta(BuildContext context, Contenido contenido) {
    return GestureDetector(
      onTap: () {
        cambiarGusta(contenido);
      },
      child: gustaCambiando
          ? CircleAvatar(
              backgroundColor: Theme.of(context)
                  .backgroundColor, // Color.fromARGB(0, 240, 0, 140),
              radius: 25,
              child: const CircularProgressIndicator(),
            )
          : Stack(children: [
              CircleAvatar(
                backgroundColor: Theme.of(context)
                    .backgroundColor, // Color.fromARGB(0, 240, 0, 140),
                radius: 25,
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Icon(
                  Icons.favorite,
                  size: 30,
                  color: contenido.gusta ? Colors.red : Colors.white,
                ),
              ),
            ]),
    );
  }

  Widget tarjeta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: GestureDetector(
        onTap: () {
          onClick(contenido);
        },
        child: Card(
          child: Column(
            children: [
              CabeceraContenido(
                contenido: contenido,
                eliminar: eliminar,
                editar: editar,
                compartir: compartir,
              ),
              contenido.titulo.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                      alignment: Alignment.topLeft,
                      child: Text(contenido.titulo,
                          style: Theme.of(context).textTheme.headline6))
                  : const SizedBox(
                      height: 0,
                    ),
              Stack(clipBehavior: Clip.none, children: [
                Visibility(
                  visible: contenido.multimedia.isNotEmpty,
                  child: imagen(context),
                ),
                Positioned(
                  top: -15,
                  right: 20,
                  child: _gusta(context, contenido),
                )
              ]),
              Visibility(
                visible: contenido.cuerpo.isNotEmpty,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    contenido.cuerpo,
                    //style: GoogleFonts.openSans(textStyle: estiloTexto),
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                    maxLines: esDetalle ? 1000 : 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return UnaColumna(child: tarjeta(context));
      },
    );
  }
}