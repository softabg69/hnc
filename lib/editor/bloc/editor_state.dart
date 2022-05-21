part of 'editor_bloc.dart';

class EditorState extends Equatable {
  const EditorState(
      {this.estado = EstadoEditor.editando, this.categorias = const []});

  final EstadoEditor estado;
  final List<Categoria> categorias;
  @override
  List<Object> get props => [estado, categorias];

  EditorState copyWith({EstadoEditor? estado, List<Categoria>? categorias}) {
    return EditorState(
        estado: estado ?? this.estado,
        categorias: categorias ?? this.categorias);
  }
}
