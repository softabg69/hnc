import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helpncare/bloc/session/session_bloc.dart';
import 'package:helpncare/components/validaciones.dart';
import 'package:helpncare/repository/hnc_repository.dart';
import 'package:helpncare/repository/service/custom_exceptions.dart';
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
    on<CargaCredenciales>(_cargaCredenciales);
    on<EmailChangedEvent>(_emailChange);
    on<PasswordChangedEvent>(_passwordChange);
    on<LoginButtonPressEvent>(_loginSubmitted);
    on<LoginGoogleEvent>(_loginGoogle);
    on<LoginGoogleError>(_loginGoogleError);
    on<LoginEstadoInicial>(_estadoInicial);
    on<LoginClose>(_cerrar);
    on<LoginRecordarEvent>(_recordar);
    on<LoginProcesadoError>(_procesadoError);
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
    const storage = FlutterSecureStorage();
    if (state.recordar) {
      Log.registra('recordar credenciales');
      await storage.write(key: 'recordar', value: 'true');
      await storage.write(key: 'email', value: state.email);
      await storage.write(key: 'pwd', value: state.pwd);
    } else {
      await storage.write(key: 'recordar', value: 'false');
    }
    try {
      final avatar = await hncRepository.authenticate(state.email, state.pwd);
      session.add(SessionLocalAuthenticationEvent(state.email, avatar));
    } on UnauthorizedException {
      emit(state.copyWith(
          estado: EstadoLogin.localError, mensaje: 'Credenciales incorrectas'));
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

  FutureOr<void> _recordar(LoginRecordarEvent event, Emitter<LoginState> emit) {
    emit(state.copyWith(recordar: event.recordar));
  }

  FutureOr<void> _cargaCredenciales(
      CargaCredenciales event, Emitter<LoginState> emit) async {
    Log.registra('cargando credenciales');
    const storage = FlutterSecureStorage();
    try {
      String? value = await storage.read(key: 'recordar');
      Log.registra('recordar: $value');
      if (value == 'true') {
        String? email = await storage.read(key: 'email');
        String? pwd = await storage.read(key: 'pwd');
        Log.registra('email: $email  pwd: $pwd');
        emit(state.copyWith(
            email: email,
            pwd: pwd,
            recordar: true,
            estado: EstadoLogin.cargadasCredenciales));
      }
    } catch (e) {
      Log.registra('error carga credenciales: $e');
    }
  }

  FutureOr<void> _procesadoError(
      LoginProcesadoError event, Emitter<LoginState> emit) {
    emit(state.copyWith(estado: EstadoLogin.procesado));
  }
}
