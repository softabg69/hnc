import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/components/validaciones.dart';
import 'package:hnc/repository/hnc_repository.dart';
import '../../components/log.dart';
import '../../components/validaciones.dart';
import '../../enumerados.dart';

part 'login_event.dart';
part 'login_state.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.hncRepository, required this.session})
      : super(LoginState()) {
    on<EmailChangedEvent>(_emailChange);
    on<PasswordChangedEvent>(_passwordChange);
    on<LoginButtonPressEvent>(_loginSubmitted);
    on<LoginGoogleEvent>(_loginGoogle);
    on<LoginGoogleError>(_loginGoogleError);
    on<LoginEstadoInicial>(_estadoInicial);
    on<LoginClose>(_cerrar);
  }

  final HncRepository hncRepository;
  final SessionBloc session;

  void _emailChange(EmailChangedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(email: event.email));
  }

  void _passwordChange(
      PasswordChangedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(pwd: event.pwd));
  }

  void _loginSubmitted(
      LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(estado: EstadoLogin.autenticandoLocal));
    try {
      await hncRepository.authenticate(state.email, state.pwd);
      session.add(SessionLocalAuthenticationEvent(state.email));
    } catch (e) {
      emit(state.copyWith(
          estado: EstadoLogin.localError,
          mensaje: (e as Exception).toString()));
    }
  }

  void _loginGoogle(LoginGoogleEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(estado: EstadoLogin.autenticandoGoogle));
    try {
      final auth = await googleSignIn.isSignedIn();
      if (auth) {
        Log.registra("ya autenticado");
        await googleSignIn.disconnect();
      }
      final res = await googleSignIn.signIn();
      if (res != null && res.email.isNotEmpty) {
        final avatar =
            await hncRepository.iniciarGoogle(res.email, res.photoUrl ?? '');
        session.add(SessionGoogleSignInEvent(res.email, avatar));
      } else {
        emit(state.copyWith(estado: EstadoLogin.googleError));
      }
    } catch (e) {
      emit(state.copyWith(estado: EstadoLogin.googleError));
      Log.registra("Error: ${e}");
    }

    // Future estaConectado = googleSignIn.isSignedIn();
    // estaConectado.then((b) {
    //   if (b) {
    //     Future desconectar = googleSignIn.disconnect();
    //     desconectar.then((value) => googleSignIn.signIn());
    //   } else {
    //     googleSignIn.signIn();
    //   }
    // });
  }

  void _loginGoogleError(
      LoginGoogleError event, Emitter<LoginState> emit) async {
    emit(state.copyWith(estado: EstadoLogin.googleError));
  }

  void _estadoInicial(
      LoginEstadoInicial event, Emitter<LoginState> emit) async {
    emit(state.copyWith(estado: EstadoLogin.inicial));
  }

  FutureOr<void> _cerrar(LoginClose event, Emitter<LoginState> emit) async {
    emit(state.copyWith(estado: EstadoLogin.cerrando));
    if (session.state.authMethod == AuthMethod.google) {
      await googleSignIn.signOut();
    }
    emit(state.copyWith(estado: EstadoLogin.cerrado));
  }
}
