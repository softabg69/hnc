part of 'login_bloc.dart';

class LoginState {
  final String email;
  bool get isValidEmail => Validaciones.emailValido(email);
  bool get datosCandidatos => isValidEmail && isValidPwd;

  final String pwd;
  bool get isValidPwd => pwd.length > 3;
  final EstadoLogin estado;
  final String mensajeError;

  LoginState(
      {this.email = '',
      this.pwd = '',
      this.estado = EstadoLogin.inicial,
      this.mensajeError = ''});

  LoginState copyWith(
      {String? email, String? pwd, EstadoLogin? estado, String? mensaje}) {
    return LoginState(
        email: email ?? this.email,
        pwd: pwd ?? this.pwd,
        estado: estado ?? this.estado,
        mensajeError: mensaje ?? mensajeError);
  }
}
