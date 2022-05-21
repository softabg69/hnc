part of 'memoria_contenido_bloc.dart';

abstract class MemoriaContenidoState extends Equatable {
  const MemoriaContenidoState();

  @override
  List<Object> get props => [];
}

class MemoriaContenidoInitial extends MemoriaContenidoState {}

class MemoriaContenidoAsignado extends MemoriaContenidoState {
  const MemoriaContenidoAsignado({required this.contenido}) : super();
  final Contenido contenido;
  @override
  List<Object> get props => [contenido];
}
