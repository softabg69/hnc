import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/perfil/widgets/perfil_screen.dart';
import 'package:hnc/repository/hnc_repository.dart';

import '../../bloc/session/session_bloc.dart';
import '../../principal/view/principal.dart';
import '../bloc/perfil_bloc.dart';

class Perfil extends StatelessWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PerfilBloc(
          sesionBloc: context.read<SessionBloc>(),
          hncRepository: context.read<HncRepository>())
        ..add(PerfilCargarEvent()),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<PerfilBloc, PerfilState>(
            listener: (context, state) {
              if (state.estado == EstadoPerfil.guardado) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Principal(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return state.estado == EstadoPerfil.cargando ||
                      state.estado == EstadoPerfil.guardamdo
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const PerfilScreen();
            },
          ),
        ),
      ),
    );
  }
}
