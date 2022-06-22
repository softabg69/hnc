import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/contenido/bloc/contenido_bloc.dart';
import 'package:helpncare/enumerados.dart';
import 'package:helpncare/stories/bloc/stories_bloc.dart';
//import 'package:helpncare/user_stories/views/stories_usuario.dart';
import 'package:helpncare/widgets/contenido_story.dart';

import '../../bloc/memoria_contenido.dart/bloc/memoria_contenido_bloc.dart';
import '../../bloc/session/session_bloc.dart';
import '../../components/dialog.dart';
import '../../components/log.dart';
import '../../contenido/widgets/block_loader.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/views/editor.dart';
import '../../repository/hnc_repository.dart';
import '../../widgets/una_columna.dart';
import '../bloc/user_stories_bloc.dart';

class VisorStoriesUsuario extends StatefulWidget {
  const VisorStoriesUsuario({Key? key, required this.usuario})
      : super(key: key);

  final String usuario;

  @override
  State<VisorStoriesUsuario> createState() => _VisorStoriesUsuarioState();
}

class _VisorStoriesUsuarioState extends State<VisorStoriesUsuario> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      Log.registra('alcanzado final contenidos');
      //widget.contenidoBloc.add(ContenidoCargarEvent());
    }
  }

  bool get _isBottom {
    //Log.registra('isBottom');
    if (!_scrollController.hasClients) return false;
    //Log.registra('isBottom 2');
    final maxScroll = _scrollController.position.maxScrollExtent;
    //Log.registra('maxScroll: $maxScroll');
    final currentScroll = _scrollController.offset;
    //Log.registra('currentScroll: $currentScroll');
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: BlocConsumer<UserStoriesBloc, UserStoriesState>(
        listener: (context, state) {
          if (state.estado == EstadoContenido.eliminado) {
            context.read<StoriesBloc>().add(StoriesCargar(
                categorias:
                    context.read<SessionBloc>().state.filtroCategorias));
          }
        },
        builder: (context, state) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              title: Text('Stories de ${widget.usuario}'),
              pinned: true,
            ),
            state.estado == EstadoContenido.cargando && state.stories.isEmpty
                ? const SliverToBoxAdapter(
                    child: UnaColumna(
                      child: BlockLoader(),
                    ),
                  )
                : state.stories.isEmpty
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
                            (_, index) => ContenidoStory(
                                  contenido: state.stories[index],
                                  esDetalle: false,
                                  //onClick: (c) async {},
                                  eliminar: (c) async {
                                    Log.registra('Eliminar userstory: $c');
                                    context.read<UserStoriesBloc>().add(
                                        UserStoriesEliminar(
                                            story: state.stories[index]));
                                  },
                                  editar: (c) async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BlocProvider(
                                                  create: ((context) => EditorBloc(
                                                      hncRepository:
                                                          context.read<
                                                              HncRepository>(),
                                                      session: context
                                                          .read<SessionBloc>(),
                                                      memoriaContenido:
                                                          context.read<
                                                              MemoriaContenidoBloc>())),
                                                  child: Editor(
                                                      contenido:
                                                          state.stories[index],
                                                      modo: 2,
                                                      guardar: (c) async {
                                                        context
                                                            .read<
                                                                UserStoriesBloc>()
                                                            .add(
                                                                UserStoriesActualizar(
                                                                    story: c));
                                                        context
                                                            .read<StoriesBloc>()
                                                            .add(StoriesCargar(
                                                                categorias: context
                                                                    .read<
                                                                        SessionBloc>()
                                                                    .state
                                                                    .filtroCategorias));
                                                        Log.registra(
                                                            'final guardar');
                                                      }),
                                                )));
                                  },
                                  compartir: (c) async {},
                                  cambiarGusta: (c) async {
                                    context.read<UserStoriesBloc>().add(
                                        UserStoriesCambiarGusta(
                                            idContenido: c.idContenido,
                                            gusta: !c.gusta));
                                  },
                                  gustaCambiando:
                                      state.stories[index].estadoGusta ==
                                          EstadoGusta.cambiando,
                                  denunciar: (c) async {
                                    context.read<UserStoriesBloc>().add(
                                        UserStoriesDenunciar(
                                            story: c.idContenido));
                                    Dialogs.snackBar(
                                        context: context,
                                        content: const Text(
                                            'Se ha notificado la denuncia'));
                                  },
                                  bloc: context.read<UserStoriesBloc>(),
                                ),
                            childCount: state.stories.length),
                      )
          ],
        ),
      ),
    );
  }
}
