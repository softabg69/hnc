import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';

@immutable
class Session extends StatelessWidget {
  const Session({Key? key, required this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (!state.isAuthenticated) {
          print("No identificado");
          return const Text('No identificado');
        } else {
          print("No identifi else");
          return child!;
        }
      },
    );
  }
}
