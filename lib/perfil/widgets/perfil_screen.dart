import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/perfil/widgets/perfil_avatar.dart';
import 'package:helpncare/perfil/widgets/perfil_categorias.dart';
import 'package:helpncare/perfil/widgets/perfil_usuario.dart';
//import 'package:http/http.dart';
import 'package:helpncare/widgets/una_columna.dart';
import '../../baja/view/baja.dart';
import '../../components/dialog.dart';
import '../../components/log.dart';
import '../../enumerados.dart';
import '../../politica_privacidad/view/politica.dart';
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
                          'Si eres mayor de 18 años, marca la casilla para poder continuar. Si no eres mayor de 18 años no puedes utilizar la aplicación.'),
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
            child: visibleMayor18
                ? UnaColumna(
                    child: SizedBox(
                      width: 400,
                      child: RichText(
                        text: TextSpan(
                            text: 'Al registrarte, aceptas nuestras ',
                            children: [
                              TextSpan(
                                  text: 'Condiciones',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const Politica(
                                            id: 2,
                                          ),
                                        ),
                                      );
                                    }),
                              const TextSpan(
                                  text:
                                      '. Obtén más información sobre cómo recopilamos, usamos y compartimos tu información en la '),
                              TextSpan(
                                  text: 'Política de privacidad',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const Politica(
                                            id: 1,
                                          ),
                                        ),
                                      );
                                    }),
                              const TextSpan(
                                  text:
                                      ', así como el uso que hacemos de las cookies y tecnologías similares en nuestra '),
                              TextSpan(
                                  text: 'Política de cookies',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const Politica(
                                            id: 3,
                                          ),
                                        ),
                                      );
                                    }),
                              const TextSpan(text: '.'),
                            ]),
                      ),
                    ),
                  )
                : const SizedBox(height: 0),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: visibleMayor18 ? 15 : 0,
            ),
          ),
          const PerfilCategorias(),
          !visibleMayor18
              ? SliverToBoxAdapter(
                  child: UnaColumna(
                    child: Center(
                      child: SizedBox(
                        width: 400,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Dialogs.continuarCancelar(
                                        context,
                                        'Baja',
                                        'Darse de baja en helpncare',
                                        '¿Seguro que deseas darte de baja en helpncare? Todos tus contenidos serán eliminados.',
                                        () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const Baja()),
                                      );
                                    });
                                  },
                                  child: const Text('Darse de baja')),
                            ]),
                      ),
                    ),
                  ),
                )
              : const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
        ],
      ),
    );
  }
}
