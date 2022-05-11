import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/hnc_repository.dart';
import '../../bloc/session/session_bloc.dart';
import '../../repository/models/categoria.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc({required this.hncRepository, required this.session})
      : super(EditorState(categorias: session.state.categoriasUsuario)) {
    on<EditorEvent>((event, emit) {});
    on<EditorGuardarEvent>(_guardar);
  }

  final HncRepository hncRepository;
  final SessionBloc session;

  FutureOr<void> _guardar(
      EditorGuardarEvent event, Emitter<EditorState> emit) async {
    emit(state.copyWith(estado: EstadoEditor.guardando));
    try {
      final conte = await hncRepository.guardarContenido(event.id, event.titulo,
          event.cuerpo, event.url, event.imagen, 1, event.categorias);
      if (event.id != null && event.id!.isNotEmpty) {
        // existente

      } else {
        // nuevo

      }
      emit(state.copyWith(estado: EstadoEditor.guardado));
    } catch (e) {
      emit(state.copyWith(estado: EstadoEditor.error));
    }
  }
}
