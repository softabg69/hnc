part of 'session_bloc.dart';

@immutable
abstract class SessionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SessionInitEvent extends SessionEvent {}

class SessionLocalAuthenticationEvent extends SessionEvent {
  SessionLocalAuthenticationEvent({required this.email, required this.token});

  final String email;
  final String token;

  @override
  List<Object?> get props => [email, token];
}

class SessionGoogleSignInEvent extends SessionEvent {
  SessionGoogleSignInEvent({required this.email, required this.token});
  final String email;
  final String token;

  @override
  List<Object?> get props => [email, token];
}

class SessionClosing extends SessionEvent {}

class SessionClose extends SessionEvent {}
