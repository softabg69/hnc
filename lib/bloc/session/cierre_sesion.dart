import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/login/bloc/login_bloc.dart';

import '../../enumerados.dart';

class CierreSesion extends StatelessWidget {
  const CierreSesion({Key? key, required this.child}) : super(key: key);

  final Widget child;

  Widget _cerrando() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state.estado == EstadoLogin.solicitudCierre) {
          return _cerrando();
        } else {
          return child;
        }
      },
    );
  }
}
