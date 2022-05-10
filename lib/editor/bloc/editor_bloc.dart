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
  }

  final HncRepository hncRepository;
  final SessionBloc session;
}
