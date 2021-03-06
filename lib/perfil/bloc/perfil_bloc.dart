import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:helpncare/repository/hnc_repository.dart';
import 'package:helpncare/repository/models/categoria.dart';

import '../../bloc/session/session_bloc.dart';
import '../../components/log.dart';
import '../../enumerados.dart';

part 'perfil_event.dart';
part 'perfil_state.dart';

class PerfilBloc extends Bloc<PerfilEvent, PerfilState> {
  PerfilBloc({required this.sesionBloc, required this.hncRepository})
      : super(const PerfilState()) {
    sessionSubscription = sesionBloc.stream.listen((state) {
      Log.registra('cambio estado session en contenido bloc');
      if (state.estado == EstadoLogin.solicitudCierre) {
        add(PerfilCerrar());
      }
    });
    Log.registra("constructor perfil bloc");
    on<PerfilCargarEvent>(_cargar);
    on<PerfilImageSelectedEvent>(_imagenSeleccionada);
    on<PerfilCategoriaCambiadaEvent>(_categoriaCambiada);
    on<PerfilProcesadoErrorEvent>(_procesadoError);
    on<PerfilGuardarEvent>(_guardar);
    on<PerfilCerrar>(_cerrar);
    on<PerfilSetNickname>(_setNickname);
  }

  @override
  Future<void> close() {
    sessionSubscription.cancel();
    return super.close();
  }

  late final StreamSubscription sessionSubscription;
  final SessionBloc sesionBloc;
  final HncRepository hncRepository;

  void _cargar(PerfilCargarEvent event, Emitter<PerfilState> emit) async {
    if (state.estado == EstadoPerfil.cargando) return;
    emit(state.copyWith(estado: EstadoPerfil.cargando));
    try {
      final perfil = await hncRepository.getPerfil();
      Log.registra('carga perfil nickname: ${perfil.nickname}');
      sesionBloc.add(SessionEstablecerNickname(perfil.nickname));
      sesionBloc.add(SessionEstablecerCategoriasUsuarioEvent(
          [...perfil.categorias.where((cat) => cat.seleccionada)]));
      if (perfil.categorias.any((cat) => cat.seleccionada)) {
        emit(state.copyWith(
            email: sesionBloc.state.email,
            nickname: perfil.nickname,
            avatar: sesionBloc.state.avatar,
            categorias: perfil.categorias,
            estado: EstadoPerfil.yaTienePerfil));
      } else {
        emit(state.copyWith(
            email: sesionBloc.state.email,
            nickname: perfil.nickname,
            avatar: sesionBloc.state.avatar,
            categorias: perfil.categorias,
            estado: EstadoPerfil.cargado));
      }
    } catch (e) {
      emit(state.copyWith(estado: EstadoPerfil.error));
      Log.registra("Error: $e");
    }
  }

  void _imagenSeleccionada(
      PerfilImageSelectedEvent event, Emitter<PerfilState> emit) async {
    emit(state.copyWith(origenAvatar: OrigenImagen.network));
    emit(state.copyWith(
        origenAvatar: OrigenImagen.bytes, bytesImg: event.image));
  }

  void _categoriaCambiada(
      PerfilCategoriaCambiadaEvent event, Emitter<PerfilState> emit) async {
    int posicion = -1;
    for (int index = 0; index < state.categorias.length; index++) {
      if (state.categorias[index].id == event.categoria.id) {
        posicion = index;
        break;
      }
    }
    if (posicion != -1) {
      final nuevasCategorias = state.categorias;
      emit(state.copyWith(categorias: []));
      nuevasCategorias[posicion] = nuevasCategorias[posicion]
          .copyWith(seleccionada: !nuevasCategorias[posicion].seleccionada);
      emit(state.copyWith(categorias: nuevasCategorias));
    }
  }

  void _guardar(PerfilGuardarEvent event, Emitter<PerfilState> emit) async {
    final seleccionadas = state.selecciondas();
    Log.registra('perfilState: $state');
    final String nickname =
        event.nickname != null ? event.nickname! : state.nickname;
    if (seleccionadas.isEmpty) {
      emit(state.copyWith(
          nickname: nickname, estado: EstadoPerfil.errorSeleccion));
      return;
    }
    emit(state.copyWith(nickname: nickname, estado: EstadoPerfil.guardando));
    try {
      Log.registra('_guardarPerfil nickname: $nickname');
      final resp = await hncRepository.actualizarPerfil(
          seleccionadas, state.bytesImg, nickname);
      if (resp.isNotEmpty) {
        sesionBloc.add(SessionActualizarAvatarEvent(resp));
      }
      sesionBloc.add(SessionEstablecerCategoriasUsuarioEvent(
          [...state.categoriasSelecciondas]));
      emit(state.copyWith(estado: EstadoPerfil.guardado));
    } catch (e) {
      Log.registra("Error al actualizar perfil: $e");
      emit(state.copyWith(estado: EstadoPerfil.errorGuardar));
    }
  }

  void _procesadoError(
      PerfilProcesadoErrorEvent event, Emitter<PerfilState> emit) async {
    emit(state.copyWith(estado: EstadoPerfil.intentoSinSeleccion));
  }

  FutureOr<void> _cerrar(PerfilCerrar event, Emitter<PerfilState> emit) async {
    Log.registra('cerrar perfil');
    emit(state.copyWith(
        email: '',
        avatar: '',
        origenAvatar: OrigenImagen.network,
        categorias: [],
        estado: EstadoPerfil.inicial,
        bytesImg: null));
  }

  FutureOr<void> _setNickname(
      PerfilSetNickname event, Emitter<PerfilState> emit) {
    Log.registra('_setNickname: $state');
    emit(state.copyWith(nickname: event.nickname));
  }
}
