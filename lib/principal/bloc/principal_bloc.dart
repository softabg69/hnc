import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'principal_event.dart';
part 'principal_state.dart';

class PrincipalBloc extends Bloc<PrincipalEvent, PrincipalState> {
  PrincipalBloc() : super(PrincipalInitial()) {
    on<PrincipalEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
