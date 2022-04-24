part of 'recuperar_password_bloc.dart';

enum EstadoRecuperarPwd { inicial, enviandoSolicitud, solicitudEnviada, error }

class RecuperarPasswordState {
  final String email;
  final EstadoRecuperarPwd estado;
  bool get isValidEmail => Validaciones.emailValido(email);

  RecuperarPasswordState(
      {this.email = '', this.estado = EstadoRecuperarPwd.inicial});

  RecuperarPasswordState copyWith(
      {String? nuevoEmail, EstadoRecuperarPwd? nuevoEstado}) {
    return RecuperarPasswordState(
        email: nuevoEmail ?? email, estado: nuevoEstado ?? estado);
  }
}
