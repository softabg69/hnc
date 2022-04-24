part of 'registro_bloc.dart';

enum EstadoRegistro { inicial, enviando, enviado, error }

class RegistroState {
  RegistroState(
      {this.email = '',
      this.pass1 = '',
      this.pass2 = '',
      this.estado = EstadoRegistro.inicial});

  final String email;
  final String pass1;
  final String pass2;
  final EstadoRegistro estado;

  RegistroState copyWith(
      {String? email, String? pass1, String? pass2, EstadoRegistro? estado}) {
    return RegistroState(
        email: email ?? this.email,
        pass1: pass1 ?? this.pass1,
        pass2: pass2 ?? this.pass2,
        estado: estado ?? this.estado);
  }

  bool get isValidEmail => Validaciones.emailValido(email);
  bool get isPass1Valid => pass1.length > 3;
  bool get isPass2Valid => pass1.length > 3;
  bool get datosValidos => isValidEmail && isPass1Valid && pass1 == pass2;
}
