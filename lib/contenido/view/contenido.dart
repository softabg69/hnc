import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/memoria_contenido.dart/bloc/memoria_contenido_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/contenido/widgets/block_loader.dart';
import 'package:hnc/editor/bloc/editor_bloc.dart';
import 'package:hnc/editor/views/editor.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:hnc/widgets/contenido_story.dart';
import 'package:hnc/widgets/una_columna.dart';
import '../../components/log.dart';
//import '../../repository/models/contenido.dart' as model;

import '../../enumerados.dart';

class Contenido extends StatefulWidget {
  const Contenido({Key? key}) : super(key: key);

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    //Log.registra('Redibujando Contenido');
    return BlocBuilder<ContenidoBloc, ContenidoState>(
      builder: (context, state) {
        //Log.registra('elementos: ${state.contenidos.length}');
        return state.estado == EstadoContenido.cargando &&
                state.contenidos.isEmpty
            ? const SliverToBoxAdapter(
                child: UnaColumna(
                  child: BlockLoader(),
                ),
              )
            : state.contenidos.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Card(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(20),
                            child: const Text(
                                'No hay contenidos que cumplan el filtro actual'),
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (_, index) => index >= state.contenidos.length
                            ? const BlockLoader()
                            : BlocProvider.value(
                                value: context.read<ContenidoBloc>(),
                                child: ContenidoStory(
                                  contenido: state.contenidos[index],
                                  esDetalle: false,
                                  eliminar: (c) async {
                                    context.read<ContenidoBloc>().add(
                                        ContenidoEliminar(
                                            contenido:
                                                state.contenidos[index]));
                                  },
                                  editar: (c) async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                                create: ((context) => EditorBloc(
                                                    hncRepository: context
                                                        .read<HncRepository>(),
                                                    session: context
                                                        .read<SessionBloc>(),
                                                    memoriaContenido: context.read<
                                                        MemoriaContenidoBloc>())),
                                                child: Editor(
                                                    contenido:
                                                        state.contenidos[index],
                                                    modo: 1,
                                                    guardar: (c) async {
                                                      context
                                                          .read<ContenidoBloc>()
                                                          .add(
                                                              ContenidoActualizaContenido(
                                                                  contenido:
                                                                      c));
                                                    }))));
                                  },
                                  compartir: (c) async {},
                                  cambiarGusta: (c) async {
                                    context.read<ContenidoBloc>().add(
                                        ContenidoCambiarGusta(
                                            idContenido: state
                                                .contenidos[index].idContenido,
                                            gusta: !state
                                                .contenidos[index].gusta));
                                  },
                                  gustaCambiando:
                                      state.contenidos[index].estadoGusta ==
                                          EstadoGusta.cambiando,
                                  bloc: context.read<ContenidoBloc>(),
                                ),
                              ),
                        childCount: state.alcanzadoFinal
                            ? state.contenidos.length
                            : state.contenidos.length + 1),
                  );
      },
    );
  }
}
