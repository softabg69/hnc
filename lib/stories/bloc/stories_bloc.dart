import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:helpncare/bloc/session/session_bloc.dart';
import 'package:helpncare/enumerados.dart';
import 'package:helpncare/repository/hnc_repository.dart';

import '../../components/log.dart';
//import '../../repository/models/contenido.dart';
import '../../repository/models/usuario_story.dart';

part 'stories_event.dart';
part 'stories_state.dart';

class StoriesBloc extends Bloc<StoriesEvent, StoriesState> {
  StoriesBloc({required this.session, required this.hncRepository})
      : super(StoriesInitial()) {
    sessionSubscription = session.stream.listen((stateSession) {
      Log.registra('cambio estado session en contenido bloc');
      if (stateSession.estado == EstadoLogin.solicitudCierre) {
        add(StoriesInicializar());
      }
    });
    // on<StoriesEvent>((event, emit) {
    // });
    on<StoriesCargar>(_cargarStories);
    on<StoriesInicializar>(_inicializar);
  }

  @override
  Future<void> close() {
    sessionSubscription.cancel();
    return super.close();
  }

  late final StreamSubscription sessionSubscription;
  final SessionBloc session;
  final HncRepository hncRepository;

  FutureOr<void> _cargarStories(
      StoriesCargar event, Emitter<StoriesState> emit) async {
    emit(StoriesCargando());
    Log.registra('_cargarStories');
    if (event.categorias.isEmpty) {
      emit(StoriesInitial());
      Log.registra('_cargarStories sin categorias');
      return;
    }
    try {
      final stories = await hncRepository.getStories(event.categorias,
          session.state.dias == FiltroFechas.ultimos5dias ? 5 : 300);
      emit(StoriesCargadas(usuariosStories: stories));
    } catch (e) {
      Log.registra('Error carga stories: $e');
      emit(StoriesError(exception: e as Exception));
    }
  }

  FutureOr<void> _inicializar(
      StoriesInicializar event, Emitter<StoriesState> emit) async {
    emit(StoriesInitial());
  }
}
