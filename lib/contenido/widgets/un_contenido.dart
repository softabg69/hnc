import 'package:flutter/material.dart';
import 'package:hnc/components/navegacion.dart';
import 'package:hnc/repository/models/contenido.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../components/configuracion.dart';
import '../../widgets/una_columna.dart';
import '../view/detalle.dart';
import 'cabecera_contenido.dart';

class UnContenido extends StatelessWidget {
  const UnContenido({Key? key, required this.contenido, this.esDetalle = false})
      : super(key: key);

  final Contenido contenido;
  final bool esDetalle;

  _launchURL(String url) async {
    if (url.isNotEmpty) {
      if (await canLaunchUrl(Uri(host: url))) {
        await launchUrl(Uri(host: url));
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return UnaColumna(child: tarjeta(context));
      },
    );
  }

  Widget envoltorioTarjeta(BuildContext context) {
    return esDetalle
        ? InteractiveViewer(
            maxScale: kIsWeb ? 1 : 5,
            child: tarjeta(context),
          )
        : tarjeta(context);
  }

  Widget imagen() {
    return esDetalle
        ? InteractiveViewer(
            maxScale: kIsWeb ? 1 : 5,
            child: Image.network(
              '${Environment().config!.baseUrlServicios}/data/imagen?id=${contenido.multimedia}',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          )
        : Image.network(
            '${Environment().config!.baseUrlServicios}/data/imagen?id=${contenido.multimedia}',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          );
  }

  Widget tarjeta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (!esDetalle) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detalle(contenido: contenido),
              ),
            );
          } else {
            _launchURL(contenido.url);
          }
        },
        child: Card(
          child: Column(
            children: [
              CabeceraContenido(
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
              Visibility(
                visible: contenido.multimedia.isNotEmpty,
                child: imagen(),
              ),
              Container(
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
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // setState(() {
                    //   widget.contenido!.gusta = !widget.contenido!.gusta;
                    //   //_gusta = !_gusta;
                    // });
                    // Llamadas.cambiarGusta(
                    //     widget.contenido!.idContenido, widget.contenido!.gusta);
                  },
                  child: Icon(
                    Icons.favorite,
                    color: contenido.gusta ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
