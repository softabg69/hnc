import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
//import 'package:hnc/principal/bloc/principal_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../components/log.dart';
import '../../enumerados.dart';
import '../../repository/models/contenido.dart';

part 'contenido_event.dart';
part 'contenido_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ContenidoBloc extends Bloc<ContenidoEvent, ContenidoState> {
  ContenidoBloc({required this.hncRepository, required this.session})
      : super(const ContenidoState()) {
    sessionSubscription = session.stream.listen((state) {
      Log.registra('cambio estado session en contenido bloc');
      add(const ContenidoCargarEvent(iniciar: true));
    });
    on<ContenidoEvent>((event, emit) {});
    on<ContenidoCargarEvent>(_cargar,
        transformer: throttleDroppable(throttleDuration));
    on<ContenidoCambiarGusta>(_cambiaGusta);
  }

  final HncRepository hncRepository;
  final SessionBloc session;
  late final StreamSubscription sessionSubscription;

  FutureOr<void> _cargar(
      ContenidoCargarEvent event, Emitter<ContenidoState> emit) async {
    if (event.iniciar) {
      emit(state.copyWith(
          estado: EstadoContenido.cargando,
          alcanzadoFinal: false,
          contenidos: []));
    } else {
      emit(state.copyWith(estado: EstadoContenido.cargando));
    }

    Log.registra('#################################');
    try {
      final resp = await hncRepository.getContenidos(
          session.state.filtroCategorias,
          session.state.dias == FiltroFechas.ultimos5dias ? 5 : 300,
          event.iniciar ? 0 : state.contenidos.length);
      Log.registra('longitud respuesta: ${resp.length}');
      if (resp.isEmpty) {
        emit(state.copyWith(
            alcanzadoFinal: true, estado: EstadoContenido.cargado));
      } else {
        if (!event.iniciar) {
          emit(
            state.copyWith(
                alcanzadoFinal: false,
                contenidos: List.of(state.contenidos)..addAll(resp),
                estado: EstadoContenido.cargado),
          );
        } else {
          emit(
            state.copyWith(
                alcanzadoFinal: false,
                contenidos: resp,
                estado: EstadoContenido.cargado),
          );
        }
        Log.registra('añadidos nuevos elementos');
      }
    } catch (e) {
      emit(state.copyWith(estado: EstadoContenido.error));
    }
  }

  FutureOr<void> _cambiaGusta(
      ContenidoCambiarGusta event, Emitter<ContenidoState> emit) async {
    Log.registra("cambia gusta: ${event.idContenido} -> ${event.gusta}");
    final copia = [...state.contenidos];
    final int seleccionado = copia.indexWhere(
      (element) => element.idContenido == event.idContenido,
    );
    if (seleccionado != -1) {
      copia[seleccionado] =
          copia[seleccionado].copyWith(estadoGusta: EstadoGusta.cambiando);
      emit(state.copyWith(contenidos: copia));
      try {
        await hncRepository.setGusta(event.idContenido, event.gusta);
        final copia = [...state.contenidos];
        final int seleccionado = copia.indexWhere(
          (element) => element.idContenido == event.idContenido,
        );
        if (seleccionado != -1) {
          copia[seleccionado] = copia[seleccionado]
              .copyWith(estadoGusta: EstadoGusta.normal, gusta: event.gusta);
          emit(state.copyWith(contenidos: copia));
        }
      } catch (e) {
        Log.registra('Error cambia gusta: $e');
      }
    }
  }
}
