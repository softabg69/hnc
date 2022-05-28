import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/perfil/widgets/perfil_avatar.dart';
import 'package:helpncare/perfil/widgets/perfil_categorias.dart';
import 'package:helpncare/perfil/widgets/perfil_usuario.dart';
import '../../components/dialog.dart';
import '../../enumerados.dart';
import '../bloc/perfil_bloc.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<PerfilBloc, PerfilState>(
      listener: (context, state) {
        if (state.estado == EstadoPerfil.errorSeleccion) {
          context.read<PerfilBloc>().add(PerfilProcesadoErrorEvent());
          Dialogs.snackBar(
              context: context,
              content: const Text('Debe seleccionar al menos una categoría'),
              color: Colors.red);
        }
      },
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Perfil de usuario'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Guardar',
                onPressed: () {
                  context.read<PerfilBloc>().add(PerfilGuardarEvent());
                },
              ),
            ],
          ),
          PerfilAvatar(),
          const PerfilUsuario(),
          const PerfilCategorias(),
        ],
      ),
    );
  }
}
