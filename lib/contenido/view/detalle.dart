import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/bloc/memoria_contenido.dart/bloc/memoria_contenido_bloc.dart';
import 'package:helpncare/bloc/session/session_bloc.dart';
import 'package:helpncare/contenido/bloc/contenido_bloc.dart';
import 'package:helpncare/repository/hnc_repository.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:helpncare/contenido/bloc/contenido_bloc.dart';
import 'package:helpncare/repository/models/contenido.dart';
import 'package:helpncare/tipos.dart';
import 'package:helpncare/widgets/contenido_story.dart';

import '../../components/dialog.dart';
import '../../components/log.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../enumerados.dart';
//import 'package:helpncare/contenido/widgets/un_contenido.dart';

class Detalle extends StatelessWidget {
  const Detalle(
      {Key? key,
      //required this.contenido,
      required this.editar,
      required this.eliminar,
      required this.compartir,
      required this.cambiarGusta,
      required this.gustaCambiando,
      required this.bloc})
      : super(key: key);

  //final Contenido contenido;
  final CallbackContenidoAsync editar;
  final CallbackContenidoAsync eliminar;
  final CallbackContenidoAsync compartir;
  final CallbackContenidoAsync cambiarGusta;
  final bool gustaCambiando;
  final Bloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoriaContenidoBloc, MemoriaContenidoState>(
      builder: ((context, state) {
        final contenido = state as MemoriaContenidoAsignado;
        Log.registra('nuevo build detalle: $contenido');
        return Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text(
              contenido.contenido.titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: SingleChildScrollView(
            child: ContenidoStory(
              contenido: contenido.contenido,
              esDetalle: true,
              editar: (c) async {
                await editar(c);
                Log.registra('después editar: $c');
                context
                    .read<MemoriaContenidoBloc>()
                    .add(MemoriaContenidoAsignar(contenido: c));
              },
              eliminar: (c) async {
                await eliminar(c);
              },
              compartir: (c) async {
                await compartir(c);
              },
              cambiarGusta: (c) async {
                await cambiarGusta(c);
                context
                    .read<MemoriaContenidoBloc>()
                    .add(MemoriaContenidoLimpiar());
                context.read<MemoriaContenidoBloc>().add(
                    MemoriaContenidoAsignar(
                        contenido: c.copyWith(gusta: !c.gusta)));
              },
              //onClick: (c) async {},
              gustaCambiando:
                  contenido.contenido.estadoGusta == EstadoGusta.cambiando,
              bloc: bloc,
              denunciar: (c) async {
                context
                    .read<ContenidoBloc>()
                    .add(ContenidoDenunciar(contenido: c.idContenido));
                Dialogs.snackBar(
                    context: context,
                    content: const Text('Se ha notificado la denuncia'));
              },
            ),
          ),
        );
      }),
    );
  }
}
