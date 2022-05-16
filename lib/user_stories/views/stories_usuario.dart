import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/user_stories/bloc/user_stories_bloc.dart';

import '../../contenido/widgets/block_loader.dart';
//import '../../contenido/widgets/un_contenido.dart';
import '../../enumerados.dart';
import '../../widgets/una_columna.dart';
import '../widgets/una_story.dart';

class StoriesUsuario extends StatelessWidget {
  const StoriesUsuario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStoriesBloc, UserStoriesState>(
      builder: (context, state) {
        //Log.registra('elementos: ${state.contenidos.length}');
        return state.estado == EstadoContenido.cargando && state.stories.isEmpty
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
                        (_, index) => index >= state.stories.length
                            ? const BlockLoader()
                            : BlocProvider.value(
                                value: context.read<UserStoriesBloc>(),
                                child: UnaStory(
                                  index: index,
                                ),
                              ),
                        childCount: state.alcanzadoFinal
                            ? state.stories.length
                            : state.stories.length + 1),
                  );
      },
    );
  }
}
