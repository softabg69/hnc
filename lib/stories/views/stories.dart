import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/memoria_contenido.dart/bloc/memoria_contenido_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/enumerados.dart';
import 'package:hnc/repository/models/usuario_story.dart';
import 'package:hnc/stories/bloc/stories_bloc.dart';
import 'package:hnc/stories/widgets/story.dart';

import '../../components/log.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/views/editor.dart';
import '../../repository/hnc_repository.dart';
import '../../repository/models/contenido.dart';
import '../../user_stories/bloc/user_stories_bloc.dart';
import '../../user_stories/views/visor_stories_usuario.dart';

class Stories extends StatelessWidget {
  const Stories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditorBloc(
          hncRepository: context.read<HncRepository>(),
          session: context.read<SessionBloc>(),
          memoriaContenido: context.read<MemoriaContenidoBloc>()),
      child: BlocBuilder<StoriesBloc, StoriesState>(
        builder: ((context, state) {
          final storiesState = state is StoriesCargadas ? state : null;
          return BlocConsumer<EditorBloc, EditorState>(
            listener: (context, state) {
              if (state.estado == EstadoEditor.guardado) {
                context.read<StoriesBloc>().add(StoriesCargar(
                    categorias:
                        context.read<SessionBloc>().state.filtroCategorias));
              }
            },
            builder: ((context, state) => SizedBox(
                  height: 102,
                  child: storiesState == null
                      ? const SizedBox(
                          height: 95,
                          width: 95,
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: ((context, index) {
                            if (index == 0) {
                              final sesion = context.read<SessionBloc>().state;
                              final UsuarioStory usuStory = UsuarioStory(
                                  idUsuario: '',
                                  usuario: 'Crear story',
                                  avatar: sesion.avatar);
                              return Story(
                                story: usuStory,
                                callback: (u) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<StoriesBloc>(),
                                        child: BlocProvider.value(
                                          value: context.read<EditorBloc>(),
                                          child: Editor(
                                            modo: 2,
                                            contenido: Contenido(modo: 2),
                                            guardar: (c) async {
                                              Log.registra(
                                                  'Después de crear nueva story');
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  Log.registra('Nueva story');
                                },
                              );
                            }
                            return Story(
                              story: storiesState.usuariosStories[index - 1],
                              callback: (us) {
                                context.read<UserStoriesBloc>().add(
                                    UserStoriesCargar(
                                        idUsuario: us.idUsuario,
                                        iniciar: true));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => VisorStoriesUsuario(
                                        usuario: us.usuario),
                                  ),
                                  //StoriesUsuario.routeName,
                                );
                              },
                            );
                          }),
                          itemCount: storiesState.usuariosStories.length + 1,
                        ),
                )),
          );
        }),
      ),
    );
  }
}
