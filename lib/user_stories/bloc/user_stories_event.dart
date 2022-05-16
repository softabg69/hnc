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
