import 'package:flutter/material.dart';
import 'package:hnc/repository/models/contenido.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/configuracion.dart';
import '../../widgets/una_columna.dart';
import 'cabecera_contenido.dart';

class UnContenido extends StatelessWidget {
  const UnContenido({Key? key, required this.contenido}) : super(key: key);

  final Contenido contenido;

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

  Widget tarjeta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _launchURL(contenido.url);
        },
        child: Card(
          child: Column(
            children: [
              CabeceraContenido(
                contenido: contenido,
              ),
              // widget.contenido!.categorias,
              // widget.contenido!.fecha,
              // widget.contenido!.creador,
              // widget.contenido!.idCreador,
              // widget.contenido!.idContenido),
              Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  alignment: Alignment.topLeft,
                  child: Text(contenido.titulo,
                      style: Theme.of(context).textTheme.headline6)),
              Visibility(
                visible: contenido.multimedia.isNotEmpty,
                child: Image.network(
                  '${Environment().config!.baseUrlServicios}/data/imagen?id=${contenido.multimedia}',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
                child: Text(
                  contenido.cuerpo,
                  //style: GoogleFonts.openSans(textStyle: estiloTexto),
                  style: Theme.of(context).textTheme.bodyText1,
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
