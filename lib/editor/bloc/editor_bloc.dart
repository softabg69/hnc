import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';

import '../../components/log.dart';
import '../../repository/hnc_repository.dart';
import '../../bloc/session/session_bloc.dart';
import '../../repository/models/categoria.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc(
      {required this.hncRepository,
      required this.session,
      required this.contenidoBloc})
      : super(EditorState(categorias: session.state.categoriasUsuario)) {
    on<EditorEvent>((event, emit) {});
    on<EditorGuardarEvent>(_guardar);
  }

  final HncRepository hncRepository;
  final SessionBloc session;
  final ContenidoBloc contenidoBloc;

  FutureOr<void> _guardar(
      EditorGuardarEvent event, Emitter<EditorState> emit) async {
    emit(state.copyWith(estado: EstadoEditor.guardando));
    try {
      Log.registra("antes de guardar contenido 1: $contenidoBloc");
      final conte = await hncRepository.guardarContenido(event.id, event.titulo,
          event.cuerpo, event.url, event.imagen, event.modo, event.categorias);
      Log.registra("después de guardar: $conte");
      if (event.modo == 1) {
        contenidoBloc.add(ContenidoActualizaContenido(contenido: conte));
      } else if (event.modo == 2) {}

      Log.registra("después actualizar");
      if (event.id != null && event.id!.isNotEmpty) {
        // existente

      } else {
        // nuevo

      }
      emit(state.copyWith(estado: EstadoEditor.guardado));
    } catch (e) {
      Log.registra("error _guardar: $e");
      emit(state.copyWith(estado: EstadoEditor.error));
    }
  }
}
