part of 'stories_bloc.dart';

abstract class StoriesEvent extends Equatable {
  const StoriesEvent();

  @override
  List<Object> get props => [];
}

class StoriesCargar extends StoriesEvent {
  const StoriesCargar({required this.categorias, this.inicializar = false})
      : super();

  final List<int> categorias;
  final bool inicializar;
}

class StoriesInicializar extends StoriesEvent {}
