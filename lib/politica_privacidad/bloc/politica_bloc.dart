import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hnc/bloc/request_status.dart';
import 'package:meta/meta.dart';

import '../../components/log.dart';
import '../../repository/hnc_repository.dart';

part 'politica_event.dart';
part 'politica_state.dart';

class PoliticaBloc extends Bloc<PoliticaEvent, PoliticaState> {
  PoliticaBloc({required this.hncRepository}) : super(PoliticaState()) {
    on<PoliticaRequestDataEvent>(_requestData);
  }

  final HncRepository hncRepository;

  void _requestData(
      PoliticaRequestDataEvent event, Emitter<PoliticaState> emit) async {
    emit(state.copyWith(requestStatus: RequestSubmitting()));
    try {
      final String politica = await hncRepository.politica();
      emit(state.copyWith(requestStatus: RequestSuccess(), texto: politica));
    } catch (e) {
      Log.registra("error petición: $e");
      emit(state.copyWith(requestStatus: RequestFailed(e as Exception)));
    }
  }
}
