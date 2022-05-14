part of 'stories_bloc.dart';

abstract class StoriesState extends Equatable {
  const StoriesState();

  @override
  List<Object> get props => [];
}

class StoriesInitial extends StoriesState {}

class StoriesCargando extends StoriesState {}

class StoriesCargadas extends StoriesState {
  const StoriesCargadas({required this.usuariosStories}) : super();

  final List<UsuarioStory> usuariosStories;
}

class StoriesError extends StoriesState {
  const StoriesError({required this.exception}) : super();

  final Exception exception;
}
