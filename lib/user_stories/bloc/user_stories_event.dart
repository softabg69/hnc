part of 'user_stories_bloc.dart';

abstract class UserStoriesEvent extends Equatable {
  const UserStoriesEvent();

  @override
  List<Object> get props => [];
}

class UserStoriesCargar extends UserStoriesEvent {
  const UserStoriesCargar({required this.idUsuario, this.iniciar = false})
      : super();
  final String idUsuario;
  final bool iniciar;
}

class UserStoriesInicializar extends UserStoriesEvent {}

class UserStoriesCambiarGusta extends UserStoriesEvent {
  const UserStoriesCambiarGusta(
      {required this.idContenido, required this.gusta});
  final String idContenido;
  final bool gusta;

  @override
  List<Object> get props => [idContenido, gusta];
}

class UserStoriesActualizar extends UserStoriesEvent {
  const UserStoriesActualizar({required this.story});
  final Contenido story;

  @override
  List<Object> get props => [story];
}

class UserStoriesEliminar extends UserStoriesEvent {
  const UserStoriesEliminar({required this.story});
  final Contenido story;
  @override
  List<Object> get props => [story];
}

class UserStoriesDenunciar extends UserStoriesEvent {
  const UserStoriesDenunciar({required this.story});
  final String story;
  @override
  List<Object> get props => [story];
}
