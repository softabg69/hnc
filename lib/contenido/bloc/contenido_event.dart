part of 'contenido_bloc.dart';

abstract class ContenidoEvent extends Equatable {
  const ContenidoEvent();

  @override
  List<Object> get props => [];
}

class ContenidoCargarEvent extends ContenidoEvent {
  const ContenidoCargarEvent({this.iniciar = false}) : super();

  final bool iniciar;
}
