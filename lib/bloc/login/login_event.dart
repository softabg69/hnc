part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class EmailChangedEvent extends LoginEvent {
  final String email;

  EmailChangedEvent({required this.email});
}

class PasswordChangedEvent extends LoginEvent {
  final String pwd;

  PasswordChangedEvent({required this.pwd});
}

class LoginButtonPressEvent extends LoginEvent {}
