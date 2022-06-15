part of 'session_bloc.dart';

class SessionState {
  final String email;
  final String nickname;
  final AuthMethod authMethod;
  final String avatar;
  final List<Categoria> categoriasUsuario;
  final List<int> filtroCategorias;
  final FiltroFechas dias;
  final EstadoLogin estado;

  bool get isAuthenticated => email.isNotEmpty;

  SessionState(
      {this.email = '',
      this.nickname = '',
      this.authMethod = AuthMethod.ninguno,
      this.avatar = '',
      this.categoriasUsuario = const [],
      this.filtroCategorias = const [],
      this.dias = FiltroFechas.todos,
      this.estado = EstadoLogin.inicial});

  SessionState copyWith(
      {String? email,
      String? nickname,
      AuthMethod? authMethod,
      String? avatar,
      List<Categoria>? categoriasUsuario,
      List<int>? filtroCategorias,
      FiltroFechas? dias,
      EstadoLogin? estado}) {
    return SessionState(
        email: email ?? this.email,
        nickname: nickname ?? this.nickname,
        authMethod: authMethod ?? this.authMethod,
        avatar: avatar ?? this.avatar,
        categoriasUsuario: categoriasUsuario ?? this.categoriasUsuario,
        filtroCategorias: filtroCategorias ?? this.filtroCategorias,
        dias: dias ?? this.dias,
        estado: estado ?? this.estado);
  }
}
