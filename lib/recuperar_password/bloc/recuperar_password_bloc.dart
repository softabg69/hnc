import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../components/log.dart';
import '../../components/validaciones.dart';
import '../../repository/hnc_repository.dart';

part 'recuperar_password_event.dart';
part 'recuperar_password_state.dart';

class RecuperarPasswordBloc
    extends Bloc<RecuperarPasswordEvent, RecuperarPasswordState> {
  RecuperarPasswordBloc({required this.hncRepository})
      : super(RecuperarPasswordState()) {
    on<RecuperarPwdEmailCambiado>(_emailChange);
    on<RecuperarPwdSolicitado>(_solicitado);
    on<RecuperarPwdTerminado>(_terminar);
  }
  final HncRepository hncRepository;

  void _emailChange(RecuperarPwdEmailCambiado event,
      Emitter<RecuperarPasswordState> emit) async {
    emit(state.copyWith(nuevoEmail: event.email));
  }

  void _solicitado(RecuperarPwdSolicitado event,
      Emitter<RecuperarPasswordState> emit) async {
    emit(state.copyWith(nuevoEstado: EstadoRecuperarPwd.enviandoSolicitud));
    try {
      await hncRepository.recuperarPwd(state.email);
      emit(state.copyWith(
          nuevoEmail: '', nuevoEstado: EstadoRecuperarPwd.solicitudEnviada));
      Log.registra('solicitud enviada');
    } catch (e) {
      Log.registra('Error: ${e.toString()}');
      emit(state.copyWith(nuevoEstado: EstadoRecuperarPwd.error));
      Log.registra('solicitud enviada error');
    }
  }

  void _terminar(
      RecuperarPwdTerminado event, Emitter<RecuperarPasswordState> emit) async {
    emit(state.copyWith(nuevoEstado: EstadoRecuperarPwd.inicial));
  }
}
