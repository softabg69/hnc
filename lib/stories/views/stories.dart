import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/repository/models/usuario_story.dart';
import 'package:hnc/stories/bloc/stories_bloc.dart';
import 'package:hnc/stories/widgets/story.dart';

import '../../components/log.dart';
import '../../contenido/bloc/contenido_bloc.dart';
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
    return BlocBuilder<StoriesBloc, StoriesState>(
      builder: ((context, state) {
        final storiesState = state is StoriesCargadas ? state : null;
        return SizedBox(
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
                      Log.registra(
                          'Usuario: ${sesion.email.substring(0, sesion.email.indexOf('@'))}');
                      final UsuarioStory usuStory = UsuarioStory(
                          idUsuario: '',
                          usuario: sesion.email
                              .substring(0, sesion.email.indexOf('@')),
                          avatar: sesion.avatar);
                      return Story(
                        story: usuStory,
                        callback: (u) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<StoriesBloc>(),
                                child: BlocProvider(
                                  create: ((context) => EditorBloc(
                                      hncRepository:
                                          context.read<HncRepository>(),
                                      session: context.read<SessionBloc>(),
                                      contenidoBloc:
                                          context.read<ContenidoBloc>())),
                                  child: Editor(
                                    modo: 2,
                                    contenido: Contenido(modo: 2),
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
                        context
                            .read<UserStoriesBloc>()
                            .add(UserStoriesCargar(idUsuario: us.idUsuario));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                VisorStoriesUsuario(usuario: us.usuario),
                          ),
                          //StoriesUsuario.routeName,
                        );
                      },
                    );
                  }),
                  itemCount: storiesState.usuariosStories.length + 1,
                ),
        );
      }),
    );
  }
}
