import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:hnc/repository/models/categoria.dart';

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
      final categorias = await hncRepository.getPerfil();
      sesionBloc.add(SessionEstablecerCategoriasUsuarioEvent(
          [...categorias.where((cat) => cat.seleccionada)]));
      if (categorias.any((cat) => cat.seleccionada)) {
        emit(state.copyWith(
            email: sesionBloc.state.email,
            avatar: sesionBloc.state.avatar,
            categorias: categorias,
            estado: EstadoPerfil.yaTienePerfil));
      } else {
        emit(state.copyWith(
            email: sesionBloc.state.email,
            avatar: sesionBloc.state.avatar,
            categorias: categorias,
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
    if (seleccionadas.isEmpty) {
      emit(state.copyWith(estado: EstadoPerfil.errorSeleccion));
      return;
    }
    emit(state.copyWith(estado: EstadoPerfil.guardando));
    try {
      final resp =
          await hncRepository.actualizarPerfil(seleccionadas, state.bytesImg);
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
}
