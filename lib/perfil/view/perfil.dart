import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/perfil/widgets/perfil_screen.dart';
import '../../principal/view/principal.dart';
import '../bloc/perfil_bloc.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

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
            if (!navegado &&
                (state.estado == EstadoPerfil.yaTienePerfil ||
                    state.estado == EstadoPerfil.guardado)) {
              navegado = true;
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
            }
          },
          builder: (context, state) {
            return state.estado == EstadoPerfil.cargando ||
                    state.estado == EstadoPerfil.guardando ||
                    state.estado == EstadoPerfil.yaTienePerfil
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
