import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/repository/models/contenido.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../components/configuracion.dart';
import '../../widgets/una_columna.dart';
import '../bloc/contenido_bloc.dart';
import '../view/detalle.dart';
import 'cabecera_contenido.dart';

class UnContenido extends StatelessWidget {
  const UnContenido({Key? key, required this.index, this.esDetalle = false})
      : super(key: key);

  final int index;
  final bool esDetalle;

  _launchURL(String url) async {
    try {
      if (url.isNotEmpty) {
        if (await canLaunchUrl(Uri(host: url))) {
          await launchUrl(Uri(host: url));
        } else {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {}
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

  Widget imagen(BuildContext context) {
    final contenido = context.read<ContenidoBloc>().state.contenidos[index];
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
        context.read<ContenidoBloc>().add(ContenidoCambiarGusta(
            idContenido: contenido.idContenido, gusta: !contenido.gusta));
      },
      child: BlocBuilder<ContenidoBloc, ContenidoState>(
        bloc: context.read<ContenidoBloc>(),
        builder: (context, state) {
          // final int index = state.contenidos.indexWhere(
          //   (element) => element.idContenido == contenido.idContenido,
          // );
          return state.contenidos[index].estadoGusta == EstadoGusta.cambiando
              ? CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .backgroundColor, // Color.fromARGB(0, 240, 0, 140),
                  radius: 30,
                  child: const CircularProgressIndicator(),
                )
              : Stack(children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context)
                        .backgroundColor, // Color.fromARGB(0, 240, 0, 140),
                    radius: 30,
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Icon(
                      Icons.favorite,
                      size: 40,
                      color: contenido.gusta ? Colors.red : Colors.white,
                    ),
                  ),
                ]);
        },
      ),
    );
  }

  Widget tarjeta(BuildContext context) {
    final contenido = context.read<ContenidoBloc>().state.contenidos[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: GestureDetector(
        onTap: () {
          if (!esDetalle) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detalle(index: index),
              ),
            );
          } else {
            _launchURL(contenido.url);
          }
        },
        child: Card(
          child: Column(
            children: [
              BlocProvider.value(
                value: context.read<ContenidoBloc>(),
                child: CabeceraContenido(
                  contenido: contenido,
                ),
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
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   alignment: Alignment.centerRight,
              //   child: GestureDetector(
              //     onTap: () {
              //       // setState(() {
              //       //   widget.contenido!.gusta = !widget.contenido!.gusta;
              //       //   //_gusta = !_gusta;
              //       // });
              //       // Llamadas.cambiarGusta(
              //       //     widget.contenido!.idContenido, widget.contenido!.gusta);
              //     },
              //     child: Icon(
              //       Icons.favorite,
              //       color: contenido.gusta ? Colors.red : Colors.grey,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
