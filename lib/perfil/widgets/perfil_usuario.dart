import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/session/session_bloc.dart';

class PerfilUsuario extends StatelessWidget {
  const PerfilUsuario({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          return Center(
            child: Text(
              state.email,
              style: const TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
