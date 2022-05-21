part of 'contenido_bloc.dart';

abstract class ContenidoEvent extends Equatable {
  const ContenidoEvent();

  @override
  List<Object> get props => [];
}

class ContenidoCargarEvent extends ContenidoEvent {
  const ContenidoCargarEvent({this.iniciar = false}) : super();

  final bool iniciar;

  @override
  List<Object> get props => [iniciar];
}

class ContenidoCambiarGusta extends ContenidoEvent {
  const ContenidoCambiarGusta({required this.idContenido, required this.gusta});
  final String idContenido;
  final bool gusta;

  @override
  List<Object> get props => [idContenido, gusta];
}

class ContenidoActualizaContenido extends ContenidoEvent {
  const ContenidoActualizaContenido({required this.contenido});
  final Contenido contenido;
  @override
  List<Object> get props => [contenido];
}

class ContenidoEliminar extends ContenidoEvent {
  const ContenidoEliminar({required this.contenido});
  final Contenido contenido;
  @override
  List<Object> get props => [contenido];
}

class ContenidoInicializar extends ContenidoEvent {}
