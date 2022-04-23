part of 'session_bloc.dart';

enum AuthMethod { ninguno, local, google }

class SessionState {
  final String email;
  final AuthMethod authMethod;
  final String urlAvatar;

  bool get isAuthenticated => email.isNotEmpty;

  SessionState({
    this.email = '',
    this.authMethod = AuthMethod.ninguno,
    this.urlAvatar = '',
  });

  SessionState copyWith(
      {String? email, AuthMethod? authMethod, String? urlAvatar}) {
    return SessionState(
        email: email ?? this.email,
        authMethod: authMethod ?? this.authMethod,
        urlAvatar: urlAvatar ?? this.urlAvatar);
  }
}
