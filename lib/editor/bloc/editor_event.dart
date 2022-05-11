part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object> get props => [];
}

class EditorGuardarEvent extends EditorEvent {
  const EditorGuardarEvent(
      {this.id,
      this.titulo,
      this.cuerpo,
      this.url,
      this.imagen,
      required this.categorias})
      : super();
  final String? id;
  final String? titulo;
  final String? cuerpo;
  final String? url;
  final Uint8List? imagen;
  final List<int> categorias;
}
