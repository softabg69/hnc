import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';

import '../components/log.dart';

@immutable
class Session extends StatelessWidget {
  const Session({Key? key, required this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (!state.isAuthenticated) {
          Log.registra("No identificado");
          return const Text('No identificado');
        } else {
          Log.registra("No identifi else");
          return child!;
        }
      },
    );
  }
}
