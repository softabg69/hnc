import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../components/validaciones.dart';
import '../../repository/hnc_repository.dart';

part 'registro_event.dart';
part 'registro_state.dart';

class RegistroBloc extends Bloc<RegistroEvent, RegistroState> {
  RegistroBloc({required this.hncRepository}) : super(RegistroState()) {
    on<EmailChangedEvent>(_emailCambiado);
    on<Pass1ChangedEvent>(_pass1Cambiado);
    on<Pass2ChangedEvent>(_pass2Cambiado);
    on<RegistroEnviar>(_enviar);
    on<RegistroTerminado>(_terminar);
  }

  final HncRepository hncRepository;

  void _emailCambiado(
      EmailChangedEvent event, Emitter<RegistroState> emit) async {
    emit(state.copyWith(email: event.email));
  }

  void _pass1Cambiado(
      Pass1ChangedEvent event, Emitter<RegistroState> emit) async {
    emit(state.copyWith(pass1: event.pass));
  }

  void _pass2Cambiado(
      Pass2ChangedEvent event, Emitter<RegistroState> emit) async {
    emit(state.copyWith(pass2: event.pass));
  }

  void _enviar(RegistroEnviar event, Emitter<RegistroState> emit) async {
    emit(state.copyWith(estado: EstadoRegistro.enviando));
    try {
      await hncRepository.registro(state.email, state.pass1);
      emit(state.copyWith(estado: EstadoRegistro.enviado));
    } catch (e) {
      emit(state.copyWith(estado: EstadoRegistro.error));
    }
  }

  void _terminar(RegistroTerminado event, Emitter<RegistroState> emit) async {
    emit(state.copyWith(estado: EstadoRegistro.inicial));
  }
}
