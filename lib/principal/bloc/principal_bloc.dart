import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../bloc/session/session_bloc.dart';
import '../../components/log.dart';
import '../../repository/hnc_repository.dart';

part 'principal_event.dart';
part 'principal_state.dart';

class PrincipalBloc extends Bloc<PrincipalEvent, PrincipalState> {
  PrincipalBloc({required this.hncRepository, required this.session})
      : super(const PrincipalState(estado: EstadoPrincipal.inicial)) {
    on<PrincipalEvent>((event, emit) {
      Log.registra("PrincEvent: $event");
    });
  }

  final HncRepository hncRepository;
  final SessionBloc session;
}
