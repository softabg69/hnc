import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/components/log.dart';
import 'package:helpncare/perfil/bloc/perfil_bloc.dart';
import 'package:helpncare/tipos.dart';

import '../../bloc/session/session_bloc.dart';

class PerfilUsuario extends StatefulWidget {
  const PerfilUsuario({Key? key, required this.callbackNickname})
      : super(key: key);

  final CallbackString callbackNickname;
  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  final _nickname = TextEditingController();
  Widget nickname() {
    return BlocBuilder<PerfilBloc, PerfilState>(
      builder: ((context, state) {
        Log.registra('BBB: ${state.nickname}');
        _nickname.text = state.nickname;
        return SizedBox(
          width: 400,
          child: TextFormField(
            controller: _nickname,
            maxLines: 1,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              label: Text('Alias'),
              errorStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            validator: (String? value) {
              if (value == null) return 'Debe definr un alias';
              if (value.length > 50) {
                return 'El alias debe ser inferior a 50 caracteres. Ahora tiene ${value.length}.';
              }
              return null;
            },
            onChanged: (String? value) {
              widget.callbackNickname.call(_nickname.text);
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          return Center(
            child: Column(
              children: [
                Text(
                  state.email,
                  style: const TextStyle(fontSize: 16),
                ),
                nickname(),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
