part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailChangedEvent extends LoginEvent {
  final String email;

  EmailChangedEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class PasswordChangedEvent extends LoginEvent {
  final String pwd;

  PasswordChangedEvent({required this.pwd});

  @override
  List<Object?> get props => [pwd];
}

class LoginEstadoInicial extends LoginEvent {}

class LoginButtonPressEvent extends LoginEvent {}

class LoginGoogleEvent extends LoginEvent {}

class LoginGoogleStart extends LoginEvent {}

class LoginGoogleError extends LoginEvent {}
