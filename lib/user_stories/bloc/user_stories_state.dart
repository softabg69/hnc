part of 'user_stories_bloc.dart';

class UserStoriesState extends Equatable {
  const UserStoriesState(
      {this.estado = EstadoContenido.inicial,
      this.stories = const [],
      this.alcanzadoFinal = false})
      : super();

  final EstadoContenido estado;
  final List<Contenido> stories;
  final bool alcanzadoFinal;

  @override
  List<Object> get props => [estado, stories, alcanzadoFinal];

  UserStoriesState copyWith(
      {EstadoContenido? estado,
      List<Contenido>? stories,
      bool? alcanzadoFinal}) {
    return UserStoriesState(
        estado: estado ?? this.estado,
        stories: stories ?? this.stories,
        alcanzadoFinal: alcanzadoFinal ?? this.alcanzadoFinal);
  }
}
