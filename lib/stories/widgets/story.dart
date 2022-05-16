import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/repository/models/usuario_story.dart';
import 'package:hnc/user_stories/bloc/user_stories_bloc.dart';
import 'package:hnc/user_stories/views/visor_stories_usuario.dart';

import '../../components/configuracion.dart';

class Story extends StatelessWidget {
  const Story({Key? key, required this.story}) : super(key: key);

  final UsuarioStory story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 0, 0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              context
                  .read<UserStoriesBloc>()
                  .add(UserStoriesCargar(idUsuario: story.idUsuario));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const VisorStoriesUsuario(),
                ),
                //StoriesUsuario.routeName,
              );
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
                  // CircleAvatar(
                  //   child: CachedNetworkImage(
                  //     imageUrl: kUrlServicios +
                  //         'datos/getavatar?idUsuario=${stori.idUsuario}',
                  //     placeholder: (context, url) =>
                  //         const CircularProgressIndicator(),
                  //     errorWidget: (context, url, error) =>
                  //         const CircleAvatar(
                  //       backgroundColor: Colors.red,
                  //       radius: 33,
                  //     ),
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            width: 80,
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
