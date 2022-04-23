part of 'session_bloc.dart';

@immutable
abstract class SessionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SessionInitEvent extends SessionEvent {}

class SessionLocalAuthenticationEvent extends SessionEvent {
  SessionLocalAuthenticationEvent(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class SessionGoogleSignInEvent extends SessionEvent {
  SessionGoogleSignInEvent(this.email);
  final String email;

  @override
  List<Object?> get props => [email];
}

class SessionClosing extends SessionEvent {}

class SessionClose extends SessionEvent {}
