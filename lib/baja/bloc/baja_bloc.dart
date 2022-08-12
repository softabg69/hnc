import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../repository/hnc_repository.dart';

part 'baja_event.dart';
part 'baja_state.dart';

class BajaBloc extends Bloc<BajaEvent, BajaState> {
  BajaBloc({required this.hncRepository}) : super(BajaInitial()) {
    on<BajaEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<BajaProcesar>(_procesaBaja);
  }
  final HncRepository hncRepository;

  FutureOr<void> _procesaBaja(
      BajaProcesar event, Emitter<BajaState> emit) async {
    emit(BajaInitial());
    try {
      await hncRepository.bajaUsuario();
      emit(BajaCompletada());
    } catch (e) {
      emit(BajaError());
    }
  }
}
