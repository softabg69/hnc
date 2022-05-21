part of 'memoria_contenido_bloc.dart';

abstract class MemoriaContenidoEvent extends Equatable {
  const MemoriaContenidoEvent();

  @override
  List<Object> get props => [];
}

class MemoriaContenidoAsignar extends MemoriaContenidoEvent {
  const MemoriaContenidoAsignar({required this.contenido});
  final Contenido contenido;

  @override
  List<Object> get props => [contenido];
}

class MemoriaContenidoLimpiar extends MemoriaContenidoEvent {}
