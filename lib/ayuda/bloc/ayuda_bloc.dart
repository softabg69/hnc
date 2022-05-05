import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ayuda_event.dart';
part 'ayuda_state.dart';

class AyudaBloc extends Bloc<AyudaEvent, AyudaState> {
  AyudaBloc() : super(AyudaInitial()) {
    on<AyudaEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
