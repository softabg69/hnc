import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hnc/repository/hnc_repository.dart';

import 'package:hnc/repository/models/categoria.dart';
import 'package:hnc/repository/models/usuario_story.dart';
import 'package:meta/meta.dart';

import '../../components/log.dart';
import '../../enumerados.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({required this.hncRepository}) : super(SessionState()) {
    on<SessionInitEvent>(_init);
    on<SessionLocalAuthenticationEvent>(_local);
    on<SessionGoogleSignInEvent>(_googleSignIn);
    on<SessionClosing>(_cerrarSession);
    on<SessionActualizarAvatarEvent>(_actualizarAvatar);
    on<SessionEstablecerCategoriasUsuarioEvent>(_establecerCategoriasUsuario);
    on<SessionEstablecerFiltroCategoriasEvent>(_establecerFiltroCategorias);
    on<SessionProcesadoEvent>(
        (event, emit) => emit(state.copyWith(estado: EstadoLogin.procesado)));
    on<SessionCambioFiltroCategoria>(_cambioFiltroCategoria);
    on<SessionCambioDias>(_cambioDias);
  }

  final HncRepository hncRepository;

  void _init(SessionInitEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(email: ''));
  }

  void _local(
      SessionLocalAuthenticationEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
        email: event.email,
        authMethod: AuthMethod.local,
        estado: EstadoLogin.autenticado));
  }

  void _googleSignIn(
      SessionGoogleSignInEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
        email: event.email,
        avatar: event.avatar,
        authMethod: AuthMethod.google,
        estado: EstadoLogin.autenticado));
  }

  void _cerrarSession(SessionClosing event, Emitter<SessionState> emit) async {
    emit(state.copyWith(estado: EstadoLogin.solicitudCierre));
    emit(state.copyWith(estado: EstadoLogin.cerrado));
    try {
      await hncRepository.desconectar();
    } catch (e) {}
    hncRepository.cierra();
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

  FutureOr<void> _cambioFiltroCategoria(
      SessionCambioFiltroCategoria event, Emitter<SessionState> emit) async {
    final List<int> nuevoFiltro = state.filtroCategorias;
    if (!state.filtroCategorias.contains(event.idCategoria)) {
      nuevoFiltro.add(event.idCategoria);
    } else {
      nuevoFiltro.remove(event.idCategoria);
    }
    emit(state.copyWith(filtroCategorias: nuevoFiltro));
  }

  FutureOr<void> _cambioDias(
      SessionCambioDias event, Emitter<SessionState> emit) async {
    emit(state.copyWith(dias: event.dias));
  }
}
