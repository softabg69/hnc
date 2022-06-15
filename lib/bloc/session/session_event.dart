part of 'session_bloc.dart';

@immutable
abstract class SessionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SessionInitEvent extends SessionEvent {}

class SessionLocalAuthenticationEvent extends SessionEvent {
  SessionLocalAuthenticationEvent(this.email, this.avatar);

  final String email;
  final String avatar;

  @override
  List<Object?> get props => [email];
}

class SessionGoogleSignInEvent extends SessionEvent {
  SessionGoogleSignInEvent(this.email, this.avatar);
  final String email;
  final String avatar;

  @override
  List<Object?> get props => [email];
}

class SessionClosing extends SessionEvent {}

class SessionActualizarAvatarEvent extends SessionEvent {
  SessionActualizarAvatarEvent(this.avatar);
  final String avatar;

  @override
  List<Object?> get props => [avatar];
}

class SessionEstablecerCategoriasUsuarioEvent extends SessionEvent {
  SessionEstablecerCategoriasUsuarioEvent(this.categorias);
  final List<Categoria> categorias;
  @override
  List<Object?> get props => [categorias];
}

class SessionEstablecerFiltroCategoriasEvent extends SessionEvent {
  SessionEstablecerFiltroCategoriasEvent(this.categorias);
  final List<int> categorias;
  @override
  List<Object?> get props => [categorias];
}

class SessionProcesadoEvent extends SessionEvent {}

class SessionCambioFiltroCategoria extends SessionEvent {
  SessionCambioFiltroCategoria(this.idCategoria) : super();
  final int idCategoria;
  @override
  List<Object?> get props => [idCategoria];
}

class SessionCambioDias extends SessionEvent {
  SessionCambioDias(this.dias) : super();
  final FiltroFechas dias;
}

class SessionEstablecerNickname extends SessionEvent {
  SessionEstablecerNickname(this.nickname) : super();
  final String? nickname;
}
