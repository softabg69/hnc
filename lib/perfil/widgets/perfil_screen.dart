import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/perfil/widgets/perfil_avatar.dart';
import 'package:helpncare/perfil/widgets/perfil_categorias.dart';
import 'package:helpncare/perfil/widgets/perfil_usuario.dart';
import '../../components/dialog.dart';
import '../../components/log.dart';
import '../../enumerados.dart';
import '../bloc/perfil_bloc.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key, this.nickname, this.mayor = false})
      : super(key: key);
  final String? nickname;
  final bool mayor;

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String? _nickname;
  bool? mayor18 = false;
  bool visibleMayor18 = true;

  @override
  void initState() {
    Log.registra('initState PerfilScreen: ${widget.nickname}');
    mayor18 = widget.mayor;
    visibleMayor18 = !widget.mayor;
    super.initState();
  }

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
                  if (mayor18 != true) {
                    Dialogs.informacion(
                      context,
                      const Text('Debes ser mayor de 18 años'),
                      const Text(
                          'Si eres mayor de 18 años, marca la casilla para poder continuar. Si no eres mayor de 18 años no podrás utilizar la aplicación y debes cerrarla inmediatamente.'),
                    );
                  } else {
                    context
                        .read<PerfilBloc>()
                        .add(PerfilGuardarEvent(nickname: _nickname));
                  }
                },
              ),
            ],
          ),
          PerfilAvatar(),
          PerfilUsuario(
            callbackNickname: (s) {
              _nickname = s;
            },
          ),
          SliverToBoxAdapter(
            child: visibleMayor18
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: mayor18,
                          onChanged: (b) {
                            setState(() {
                              mayor18 = b;
                            });
                          }),
                      const Text(' Soy mayor de 18 años')
                    ],
                  )
                : const SizedBox(
                    height: 0,
                  ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: visibleMayor18 ? 15 : 0,
            ),
          ),
          const PerfilCategorias(),
        ],
      ),
    );
  }
}
