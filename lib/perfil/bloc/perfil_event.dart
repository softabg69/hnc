part of 'perfil_bloc.dart';

abstract class PerfilEvent extends Equatable {
  const PerfilEvent();

  @override
  List<Object> get props => [];
}

class PerfilCargarEvent extends PerfilEvent {}

class PerfilImageSelectedEvent extends PerfilEvent {
  const PerfilImageSelectedEvent({required this.image});

  final Uint8List image;
  @override
  List<Object> get props => [image];
}

class PerfilCategoriaCambiadaEvent extends PerfilEvent {
  const PerfilCategoriaCambiadaEvent({required this.categoria});

  final Categoria categoria;
  @override
  List<Object> get props => [categoria];
}

class PerfilGuardarEvent extends PerfilEvent {}

class PerfilProcesadoErrorEvent extends PerfilEvent {}

class PerfilCerrar extends PerfilEvent {}
