part of 'session_bloc.dart';

enum AuthMethod { ninguno, local, google }

class SessionState {
  final String email;
  final AuthMethod authMethod;
  final String avatar;
  final List<int> filtroCategorias;

  bool get isAuthenticated => email.isNotEmpty;

  SessionState(
      {this.email = '',
      this.authMethod = AuthMethod.ninguno,
      this.avatar = '',
      this.filtroCategorias = const []});

  SessionState copyWith(
      {String? email,
      AuthMethod? authMethod,
      String? avatar,
      List<int>? filtroCategorias}) {
    return SessionState(
        email: email ?? this.email,
        authMethod: authMethod ?? this.authMethod,
        avatar: avatar ?? this.avatar,
        filtroCategorias: filtroCategorias ?? this.filtroCategorias);
  }
}
