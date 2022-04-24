part of 'recuperar_password_bloc.dart';

@immutable
abstract class RecuperarPasswordEvent extends Equatable {
  const RecuperarPasswordEvent();

  @override
  List<Object> get props => [];
}

class RecuperarPwdEmailCambiado extends RecuperarPasswordEvent {
  final String email;

  const RecuperarPwdEmailCambiado({required this.email});

  @override
  List<Object> get props => [email];
}

class RecuperarPwdSolicitado extends RecuperarPasswordEvent {}

class RecuperarPwdEnviado extends RecuperarPasswordEvent {}

class RecuperarPwdError extends RecuperarPasswordEvent {}

class RecuperarPwdTerminado extends RecuperarPasswordEvent {}
