part of 'session_bloc.dart';

enum AuthMethod { ninguno, local, google }

class SessionState {
  final String email;
  final AuthMethod authMethod;
  final String avatar;
  final List<Categoria> categoriasUsuario;
  final List<int> filtroCategorias;
  final FiltroFechas dias;
  final EstadoLogin estado;

  bool get isAuthenticated => email.isNotEmpty;

  SessionState(
      {this.email = '',
      this.authMethod = AuthMethod.ninguno,
      this.avatar = '',
      this.categoriasUsuario = const [],
      this.filtroCategorias = const [],
      this.dias = FiltroFechas.ultimos5dias,
      this.estado = EstadoLogin.inicial});

  SessionState copyWith(
      {String? email,
      AuthMethod? authMethod,
      String? avatar,
      List<Categoria>? categoriasUsuario,
      List<int>? filtroCategorias,
      FiltroFechas? dias,
      EstadoLogin? estado}) {
    return SessionState(
        email: email ?? this.email,
        authMethod: authMethod ?? this.authMethod,
        avatar: avatar ?? this.avatar,
        categoriasUsuario: categoriasUsuario ?? this.categoriasUsuario,
        filtroCategorias: filtroCategorias ?? this.filtroCategorias,
        dias: dias ?? this.dias,
        estado: estado ?? this.estado);
  }
}
