import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/repository/models/contenido.dart';
import 'package:helpncare/user_stories/bloc/user_stories_bloc.dart';

import '../../components/log.dart';
import '../../contenido/widgets/block_loader.dart';
//import '../../contenido/widgets/un_contenido.dart';
import '../../enumerados.dart';
import '../../widgets/contenido_story.dart';
import '../../widgets/una_columna.dart';
import '../widgets/una_story.dart';

class StoriesUsuario extends StatelessWidget {
  const StoriesUsuario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserStoriesBloc, UserStoriesState>(
      builder: (context, state) {
        Log.registra('elementos: ${state.stories.length}');
        Log.registra('estado: ${state.estado}');
        return state.estado == EstadoContenido.cargando && state.stories.isEmpty
            ? SliverToBoxAdapter(
                child: UnaColumna(
                  child: Card(
                    child: Container(
                      color: Colors.blue,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                  //BlockLoader(),
                ),
              )
            : state.stories.isEmpty
                ? SliverToBoxAdapter(
                    child: Card(
                      child: Container(
                        color: Colors.green,
                        height: 200,
                        width: double.infinity,
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //     margin: const EdgeInsets.all(20),
                    //     child: Card(
                    //       child: Container(
                    //         margin: const EdgeInsets.all(20),
                    //         padding: const EdgeInsets.all(20),
                    //         child: const Text(
                    //             'No hay contenidos que cumplan el filtro actual'),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (_, index) => Card(
                              child: Container(
                                width: double.infinity,
                                height: 70,
                                color: Colors.orange,
                              ),
                            ),
                        childCount: 20),
                  );
        // SliverToBoxAdapter(
        //     child: Padding(
        //       padding: const EdgeInsets.all(8),
        //       child: Card(
        //           child: Container(
        //         color: Colors.purple,
        //         height: 200,
        //         width: double.infinity,
        //       )),
        //     ),
        //   );
        // SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //         (context, index) => Padding(
        //               padding: const EdgeInsets.all(8),
        //               child: Card(
        //                 child: Container(
        //                   color: Colors.red,
        //                   height: 200,
        //                   width: double.infinity,
        //                 ),
        //               ),
        //             ),
        //         childCount: 20),
        //   );
        //     ),,)),
        // SliverList(
        //     delegate: SliverChildBuilderDelegate(
        //         (_, index) => index >= state.stories.length
        //             ? const BlockLoader()
        //             : SliverToBoxAdapter(
        //                 child: Card(
        //                   child: Container(
        //                     color: Colors.red,
        //                     height: 200,
        //                     width: double.infinity,
        //                   ),
        //                   // ContenidoStory(
        //                   //   esDetalle: false,
        //                   //   contenido: state.stories[index],
        //                   //   onClick: (c) {},
        //                   //   editar: (c) {},
        //                   //   eliminar: (c) {},
        //                   //   compartir: (c) {},
        //                   //   cambiarGusta: (c) {},
        //                   //   gustaCambiando:
        //                   //       state.stories[index].estadoGusta ==
        //                   //           EstadoGusta.cambiando,
        //                   // ),
        //                 ),
        //               ),
        //         childCount: state.alcanzadoFinal
        //             ? state.stories.length
        //             : state.stories.length + 1),
        //   );
      },
    );
  }
}
