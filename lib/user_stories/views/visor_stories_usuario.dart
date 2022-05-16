import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/enumerados.dart';
import 'package:hnc/user_stories/views/stories_usuario.dart';
import 'package:hnc/widgets/contenido_story.dart';

import '../../components/log.dart';
import '../bloc/user_stories_bloc.dart';

class VisorStoriesUsuario extends StatefulWidget {
  const VisorStoriesUsuario({Key? key}) : super(key: key);

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
      body: BlocBuilder<UserStoriesBloc, UserStoriesState>(
        builder: (context, state) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            // SliverToBoxAdapter(
            //   child: Card(
            //     child: Container(
            //       color: Colors.blue,
            //       height: 200,
            //       width: double.infinity,
            //     ),
            //   ),
            // ),
            //StoriesUsuario(),
            const SliverAppBar(
              title: Text('Stories de '),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (_, index) => ContenidoStory(
                      contenido: state.stories[index],
                      onClick: (c) {},
                      eliminar: (c) {},
                      editar: (c) {},
                      compartir: (c) {},
                      cambiarGusta: (c) {
                        context.read<UserStoriesBloc>().add(
                            UserStoriesCambiarGusta(
                                idContenido: c.idContenido, gusta: !c.gusta));
                      },
                      gustaCambiando: state.stories[index].estadoGusta ==
                          EstadoGusta.cambiando),
                  childCount: state.stories.length),
            )
          ],
        ),
      ),
    );
  }
}
