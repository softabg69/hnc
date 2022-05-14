import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/perfil/widgets/perfil_screen.dart';
import 'package:hnc/stories/bloc/stories_bloc.dart';
import '../../enumerados.dart';
import '../../principal/view/principal.dart';
import '../bloc/perfil_bloc.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key, this.inicio = true}) : super(key: key);

  final bool inicio;

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  bool navegado = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<PerfilBloc, PerfilState>(
          listener: (context, state) {
            if (widget.inicio &&
                !navegado &&
                (state.estado == EstadoPerfil.yaTienePerfil ||
                    state.estado == EstadoPerfil.guardado)) {
              navegado = true;
              final categorias =
                  context.read<SessionBloc>().state.filtroCategorias;
              context
                  .read<StoriesBloc>()
                  .add(StoriesCargar(categorias: categorias));

              // context.read<SessionBloc>().add(
              //     SessionEstablecerCategoriasUsuarioEvent(state.categorias));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Principal(
                    contenidoBloc: context.read<ContenidoBloc>(),
                  ),
                ),
              );
            } else if (!widget.inicio &&
                state.estado == EstadoPerfil.guardado) {
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return widget.inicio &&
                    (state.estado == EstadoPerfil.cargando ||
                        state.estado == EstadoPerfil.guardando ||
                        state.estado == EstadoPerfil.yaTienePerfil)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const PerfilScreen();
          },
        ),
      ),
    );
  }
}
