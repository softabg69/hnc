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
      required this.modo,
      required this.categorias,
      required this.guardar})
      : super();
  final String? id;
  final String? titulo;
  final String? cuerpo;
  final String? url;
  final Uint8List? imagen;
  final int modo;
  final List<int> categorias;
  final CallbackContenidoAsync guardar;
}
