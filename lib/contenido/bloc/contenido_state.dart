part of 'contenido_bloc.dart';

class ContenidoState extends Equatable {
  const ContenidoState(
      {this.contenidos = const [],
      this.estado = EstadoContenido.inicial,
      this.alcanzadoFinal = false});

  final EstadoContenido estado;
  final List<Contenido> contenidos;
  final bool alcanzadoFinal;

  @override
  List<Object> get props => [estado, contenidos];

  ContenidoState copyWith(
      {EstadoContenido? estado,
      List<Contenido>? contenidos,
      bool? alcanzadoFinal}) {
    return ContenidoState(
        contenidos: contenidos ?? this.contenidos,
        estado: estado ?? this.estado,
        alcanzadoFinal: alcanzadoFinal ?? this.alcanzadoFinal);
  }
}
