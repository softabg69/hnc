import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hnc/repository/models/categoria.dart';
import 'package:meta/meta.dart';

import '../../components/log.dart';
import '../../login/bloc/login_bloc.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionState()) {
    on<SessionInitEvent>(_init);
    on<SessionLocalAuthenticationEvent>(_local);
    on<SessionGoogleSignInEvent>(_googleSignIn);
    on<SessionClosing>(_closeSession);
    on<SessionActualizarAvatarEvent>(_actualizarAvatar);
    on<SessionEstablecerCategoriasUsuarioEvent>(_establecerCategoriasUsuario);
    on<SessionEstablecerFiltroCategoriasEvent>(_establecerFiltroCategorias);
    on<SessionProcesadoEvent>(
        (event, emit) => emit(state.copyWith(estado: EstadoLogin.procesado)));
  }

  void _init(SessionInitEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(email: ''));
  }

  void _local(
      SessionLocalAuthenticationEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(email: event.email, authMethod: AuthMethod.local));
  }

  void _googleSignIn(
      SessionGoogleSignInEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
        email: event.email,
        avatar: event.avatar,
        authMethod: AuthMethod.google));
  }

  void _closeSession(SessionClosing event, Emitter<SessionState> emit) async {
    if (state.authMethod == AuthMethod.google) {}
  }

  void _actualizarAvatar(
      SessionActualizarAvatarEvent event, Emitter<SessionState> emit) async {
    Log.registra("Actualizado avatar: ${event.avatar}");
    emit(state.copyWith(avatar: event.avatar));
  }

  void _establecerCategoriasUsuario(
      SessionEstablecerCategoriasUsuarioEvent event,
      Emitter<SessionState> emit) async {
    Log.registra('categorias usuario: ${event.categorias.length}');
    emit(state.copyWith(
        categoriasUsuario: event.categorias,
        filtroCategorias: event.categorias.map((e) => e.id).toList()));
  }

  void _establecerFiltroCategorias(SessionEstablecerFiltroCategoriasEvent event,
      Emitter<SessionState> emit) async {
    emit(state.copyWith(filtroCategorias: event.categorias));
  }
}
