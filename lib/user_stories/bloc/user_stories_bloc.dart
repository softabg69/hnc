import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../bloc/session/session_bloc.dart';
import '../../components/log.dart';
import '../../enumerados.dart';
import '../../repository/hnc_repository.dart';
import '../../repository/models/contenido.dart';

part 'user_stories_event.dart';
part 'user_stories_state.dart';

class UserStoriesBloc extends Bloc<UserStoriesEvent, UserStoriesState> {
  UserStoriesBloc({required this.hncRepository, required this.session})
      : super(const UserStoriesState()) {
    sessionSubscription = session.stream.listen((stateSession) {
      Log.registra('cambio estado session en user stories bloc');

      if (stateSession.estado == EstadoLogin.solicitudCierre) {
        add(UserStoriesInicializar());
      }
    });
    on<UserStoriesEvent>((event, emit) {
      Log.registra('UserStoriesEvent: $event');
    });
    on<UserStoriesCargar>(_cargar);
  }
  @override
  Future<void> close() {
    sessionSubscription.cancel();
    return super.close();
  }

  final HncRepository hncRepository;
  final SessionBloc session;
  late final StreamSubscription sessionSubscription;

  FutureOr<void> _cargar(
      UserStoriesCargar event, Emitter<UserStoriesState> emit) async {
    if (event.iniciar) {
      emit(state.copyWith(
          estado: EstadoContenido.cargando,
          alcanzadoFinal: false,
          stories: []));
    } else {
      emit(state.copyWith(estado: EstadoContenido.cargando));
    }
    Log.registra('############# stories ################');
    try {
      final resp = await hncRepository.getStoriesUsuario(
          event.idUsuario,
          session.state.filtroCategorias,
          session.state.dias == FiltroFechas.ultimos5dias ? 5 : 300,
          event.iniciar ? 0 : state.stories.length);
      Log.registra('longitud respuesta: ${resp.length}');
      if (resp.isEmpty) {
        emit(state.copyWith(
            alcanzadoFinal: true, estado: EstadoContenido.cargado));
      } else {
        if (!event.iniciar) {
          emit(
            state.copyWith(
                alcanzadoFinal: false,
                stories: List.of(state.stories)..addAll(resp),
                estado: EstadoContenido.cargado),
          );
        } else {
          emit(
            state.copyWith(
                alcanzadoFinal: false,
                stories: resp,
                estado: EstadoContenido.cargado),
          );
        }
        Log.registra('añadidos nuevos elementos stories');
      }
    } catch (e) {
      emit(state.copyWith(estado: EstadoContenido.error));
    }
  }

  FutureOr<void> _inicializar(
      UserStoriesInicializar event, Emitter<UserStoriesState> emit) async {
    Log.registra("Inicializar contenido");
    emit(state.copyWith(
        estado: EstadoContenido.inicial, stories: [], alcanzadoFinal: false));
  }
}
