part of 'politica_bloc.dart';

class PoliticaState {
  final String texto;
  final RequestStatus requestStatus;

  PoliticaState(
      {this.texto = '', this.requestStatus = const RequestInitialStatus()});

  PoliticaState copyWith({
    String? texto,
    RequestStatus? requestStatus,
  }) {
    return PoliticaState(
        texto: texto ?? this.texto,
        requestStatus: requestStatus ?? this.requestStatus);
  }
}
