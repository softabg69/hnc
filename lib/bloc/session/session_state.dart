part of 'session_bloc.dart';

enum AuthMethod { ninguno, local, google }

class SessionState {
  final String email;
  final String token;
  final AuthMethod authMethod;
  final String urlAvatar;

  bool get isAuthenticated => token.isNotEmpty;

  SessionState({
    this.email = '',
    this.token = '',
    this.authMethod = AuthMethod.ninguno,
    this.urlAvatar = '',
  });

  SessionState copyWith(
      {String? email,
      String? token,
      AuthMethod? authMethod,
      String? urlAvatar}) {
    return SessionState(
        email: email ?? this.email,
        token: token ?? this.token,
        authMethod: authMethod ?? this.authMethod,
        urlAvatar: urlAvatar ?? this.urlAvatar);
  }
}
