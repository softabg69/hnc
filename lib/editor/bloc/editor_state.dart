part of 'editor_bloc.dart';

enum EstadoEditor { editando, guardando }

class EditorState extends Equatable {
  const EditorState(
      {this.estado = EstadoEditor.editando, this.categorias = const []});

  final EstadoEditor estado;
  final List<Categoria> categorias;
  @override
  List<Object> get props => [];
}
