import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc() : super(SessionState()) {
    on<SessionInitEvent>(_init);
    on<SessionLocalAuthenticationEvent>(_local);
    on<SessionGoogleSignInEvent>(_googleSignIn);
    on<SessionClosing>(_closeSession);
  }

  void _init(SessionInitEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith());
  }

  void _local(
      SessionLocalAuthenticationEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
        email: event.email, token: event.token, authMethod: AuthMethod.local));
  }

  void _googleSignIn(
      SessionGoogleSignInEvent event, Emitter<SessionState> emit) async {
    emit(state.copyWith(
        email: event.email, token: event.token, authMethod: AuthMethod.google));
  }

  void _closeSession(SessionClosing event, Emitter<SessionState> emit) async {
    if (state.authMethod == AuthMethod.google) {}
  }
}
