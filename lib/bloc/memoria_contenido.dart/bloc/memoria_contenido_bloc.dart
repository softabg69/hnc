import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../components/log.dart';
import '../../../repository/models/contenido.dart';

part 'memoria_contenido_event.dart';
part 'memoria_contenido_state.dart';

class MemoriaContenidoBloc
    extends Bloc<MemoriaContenidoEvent, MemoriaContenidoState> {
  MemoriaContenidoBloc() : super(MemoriaContenidoInitial()) {
    on<MemoriaContenidoAsignar>((event, emit) {
      emit(MemoriaContenidoInitial());
      Log.registra('Asigna contenido: ${event.contenido}');
      emit(MemoriaContenidoAsignado(contenido: event.contenido));
    });

    on<MemoriaContenidoLimpiar>(((event, emit) {
      emit(MemoriaContenidoInitial());
    }));
  }
}
