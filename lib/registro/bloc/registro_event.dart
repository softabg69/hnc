part of 'registro_bloc.dart';

abstract class RegistroEvent extends Equatable {
  const RegistroEvent();

  @override
  List<Object> get props => [];
}

class EmailChangedEvent extends RegistroEvent {
  final String email;

  const EmailChangedEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class Pass1ChangedEvent extends RegistroEvent {
  final String pass;

  const Pass1ChangedEvent({required this.pass});

  @override
  List<Object> get props => [pass];
}

class Pass2ChangedEvent extends RegistroEvent {
  final String pass;

  const Pass2ChangedEvent({required this.pass});

  @override
  List<Object> get props => [pass];
}

class RegistroEnviar extends RegistroEvent {}

class RegistroTerminado extends RegistroEvent {}
