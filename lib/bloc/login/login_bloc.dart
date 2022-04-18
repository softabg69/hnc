import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hnc/bloc/login/form_submission_status.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/components/configuracion.dart';
import 'package:hnc/repository/hnc_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: kIsWeb
      ? Environment().config!.googleWeb
      : '177362842463-mq4d4dfb0t5j6hvs1s1mr9oh8d5hak1c.apps.googleusercontent.com', // Environment().config!.googleAndroid,
  scopes: <String>[
    'email',
  ],
);

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.hncRepository, required this.session})
      : super(LoginState()) {
    on<EmailChangedEvent>(_emailChange);
    on<PasswordChangedEvent>(_passwordChange);
    on<LoginButtonPressEvent>(_loginSubmitted);
    on<LoginGoogleEvent>(_loginGoogle);
    on<LoginGoogleError>(_loginGoogleError);
  }

  final HncRepository hncRepository;
  final SessionBloc session;

  void _emailChange(EmailChangedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(email: event.email));
  }

  void _passwordChange(
      PasswordChangedEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(pwd: event.pwd));
  }

  void _loginSubmitted(
      LoginButtonPressEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: FormSubmitting()));
    try {
      print("antes");
      final token = await hncRepository.authenticate(state.email, state.pwd);
      //emit(state.copyWith(formStatus: SubmittingSuccess()));
      print("token recibido: $token");
      session.add(
          SessionLocalAuthenticationEvent(email: state.email, token: token));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
    }
  }

  void _loginGoogle(LoginGoogleEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: ExternalLoginGoogle()));
    //print("config: ${googleSignIn.clientId}");
    try {
      final auth = await googleSignIn.isSignedIn();
      if (auth) {
        print("ya autenticado");
        await googleSignIn.disconnect();
      }
      print("previo");
      final res = await googleSignIn.signIn();
      print("ya");
      if (res != null && res.email != '') {
        session.add(
            SessionGoogleSignInEvent(email: res.email, token: 'sSDFSDFsdfsdf'));
      } else {
        session.add(SessionGoogleSignInEvent(email: '', token: ''));
      }
    } catch (e) {
      emit(state.copyWith(formStatus: ExternalLoginGoogleError()));
      print("Error: ${e}");
    }

    // Future estaConectado = googleSignIn.isSignedIn();
    // estaConectado.then((b) {
    //   if (b) {
    //     Future desconectar = googleSignIn.disconnect();
    //     desconectar.then((value) => googleSignIn.signIn());
    //   } else {
    //     googleSignIn.signIn();
    //   }
    // });
  }

  void _loginGoogleError(
      LoginGoogleError event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: ExternalLoginGoogleError()));
  }
}
