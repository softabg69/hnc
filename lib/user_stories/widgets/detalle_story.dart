import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:helpncare/contenido/bloc/contenido_bloc.dart';
//import 'package:helpncare/contenido/widgets/un_contenido.dart';
import 'package:helpncare/user_stories/bloc/user_stories_bloc.dart';
//import 'package:helpncare/user_stories/widgets/una_story.dart';
import 'package:helpncare/widgets/contenido_story.dart';

import '../../components/dialog.dart';
import '../../contenido/bloc/contenido_bloc.dart';
import '../../enumerados.dart';

class DetalleStory extends StatelessWidget {
  const DetalleStory({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<UserStoriesBloc>(),
      child: BlocBuilder<UserStoriesBloc, UserStoriesState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              context.read<UserStoriesBloc>().state.stories[index].titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: Colors.grey,
          body: SingleChildScrollView(
            child: ContenidoStory(
              esDetalle: false,
              contenido: state.stories[index],
              //onClick: (c) async {},
              editar: (c) async {},
              eliminar: (c) async {},
              compartir: (c) async {},
              cambiarGusta: (c) async {},
              gustaCambiando:
                  state.stories[index].estadoGusta == EstadoGusta.cambiando,
              bloc: context.read<UserStoriesBloc>(),
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
        ),
      ),
    );
  }
}
