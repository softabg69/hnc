import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:helpncare/widgets/una_columna.dart';
import 'package:universal_platform/universal_platform.dart';

import '../compartido/widgets/cabecera_contenido_compartido.dart';
import '../components/configuracion.dart';
import '../repository/models/contenido.dart';

class ContenidoStoryCompartido extends StatelessWidget {
  const ContenidoStoryCompartido({Key? key, required this.contenido})
      : super(key: key);

  final Contenido contenido;

  Widget imagen(BuildContext context) {
    return InteractiveViewer(
      maxScale: UniversalPlatform.isWeb ? 1 : 5,
      child: Image.network(
        '${Environment().config!.baseUrlServicios}/data/imagen?id=${contenido.multimedia}',
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget tarjeta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: Card(
        child: Column(
          children: [
            CabeceraContenidoCompartido(
              contenido: contenido,
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
                  maxLines: 1000,
                ),
              ),
            ),
          ],
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
