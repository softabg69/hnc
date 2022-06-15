part of 'login_bloc.dart';

class LoginState {
  final String email;
  final bool recordar;
  bool get isValidEmail => Validaciones.emailValido(email);
  bool get datosCandidatos => isValidEmail && isValidPwd;

  final String pwd;
  bool get isValidPwd => pwd.length > 3;
  final EstadoLogin estado;
  final String mensajeError;

  LoginState(
      {this.email = '',
      this.recordar = false,
      this.pwd = '',
      this.estado = EstadoLogin.inicial,
      this.mensajeError = ''});

  LoginState copyWith(
      {String? email,
      String? pwd,
      bool? recordar,
      EstadoLogin? estado,
      String? mensaje}) {
    return LoginState(
        email: email ?? this.email,
        pwd: pwd ?? this.pwd,
        recordar: recordar ?? this.recordar,
        estado: estado ?? this.estado,
        mensajeError: mensaje ?? mensajeError);
  }
}
