import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';

import '../../components/log.dart';
import '../../repository/models/contenido.dart';

part 'contenido_event.dart';
part 'contenido_state.dart';

class ContenidoBloc extends Bloc<ContenidoEvent, ContenidoState> {
  ContenidoBloc({required this.hncRepository, required this.session})
      : super(const ContenidoState()) {
    sessionSubscription = session.stream.listen((state) {
      Log.registra('cambio estado session en contenido bloc');
      filtroCategorias = state.filtroCategorias;
      dias = state.dias;
    });
    on<ContenidoEvent>((event, emit) {});
    on<ContenidoCargarEvent>(_cargar);
  }

  final HncRepository hncRepository;
  final SessionBloc session;
  late final StreamSubscription sessionSubscription;
  List<int> filtroCategorias = [];
  int dias = 5;

  FutureOr<void> _cargar(
      ContenidoCargarEvent event, Emitter<ContenidoState> emit) async {
    emit(state.copyWith(estado: EstadoContenido.cargando));
    try {
      final resp = await hncRepository.getContenidos(
          filtroCategorias, dias, state.contenidos.length);
      Log.registra('longitud respuesta: ${resp.length}');
      if (resp.isEmpty) {
        emit(state.copyWith(alcanzadoFinal: true));
      } else {
        emit(
          state.copyWith(
            alcanzadoFinal: false,
            contenidos: List.of(state.contenidos)..addAll(resp),
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(estado: EstadoContenido.error));
    }
  }
}
