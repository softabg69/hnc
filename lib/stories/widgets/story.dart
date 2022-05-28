import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/repository/models/usuario_story.dart';
import 'package:helpncare/tipos.dart';
//import 'package:helpncare/user_stories/bloc/user_stories_bloc.dart';
//import 'package:helpncare/user_stories/views/visor_stories_usuario.dart';

import '../../components/configuracion.dart';

class Story extends StatelessWidget {
  const Story({Key? key, required this.story, required this.callback})
      : super(key: key);

  final UsuarioStory story;
  final CallbackUsuarioStory callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              callback(story);
            },
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  radius: 35,
                ),
                Positioned(
                  top: 5,
                  left: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "${Environment().config!.baseUrlServicios}/data/avatarusuario?id=${story.avatar}",
                    ),
                    backgroundColor: Colors.grey.shade200,
                    radius: 30,
                  ),
                ),
                story.idUsuario.isEmpty
                    ? Positioned(
                        right: -10,
                        bottom: -10,
                        child: Icon(
                          Icons.add,
                          size: 50,
                          color: Theme.of(context).primaryColor,
                          shadows: const [Shadow()],
                        ))
                    : const SizedBox(
                        height: 0,
                      )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 90,
            child: Center(
              child: FittedBox(
                child: Text(
                  story.usuario,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
