import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hnc/bloc/login/form_submission_status.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:meta/meta.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';

part 'login_event.dart';
part 'login_state.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: kIsWeb ? dotenv.get('GOOGLE_WEB') : dotenv.get('GOOGLE_ANDROID'),
  scopes: <String>[
    'email',
  ],
);

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.hncRepository, required this.session})
      : super(LoginState()) {
    subscripcion = registraCambioGoogle();
    print("subscripción a Google");
    on<EmailChangedEvent>(_emailChange);
    on<PasswordChangedEvent>(_passwordChange);
    on<LoginButtonPressEvent>(_loginSubmitted);
    on<LoginGoogleEvent>(_loginGoogle);
  }

  final HncRepository hncRepository;
  final SessionBloc session;
  //GoogleSignInAccount? _currentUser;
  StreamSubscription<GoogleSignInAccount?>? subscripcion;

  StreamSubscription<GoogleSignInAccount?>? registraCambioGoogle() {
    return googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) {
      print("cambio en Google: $account");
      if (account != null) {
        //print(_currentUser?.email);
        String email = account != null ? account.email : '';
        session.add(
            SessionGoogleSignInEvent(email: email, token: 'sSDFSDFsdfsdf'));
        //print("Email: $email");

        // Llamadas.iniciarGoogle(email, (r) {
        //   //print("r: $r");
        //   if (r == null || r == '') {
        //     setState(() {
        //       _procesando = '';
        //     });
        //     return;
        //   }
        //   var resp = json.decode(r);
        //   //print("json: $json");
        //   token = resp['token'];
        //   //print("token: $token");
        //   if (token == '') {
        //     setState(() {
        //       _procesando = '';
        //     });
        //     return;
        //   }
      } else {
        // logout ?

      }
    });
  }

  void dispose() {
    subscripcion?.cancel();
  }

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
      final token = await hncRepository.authenticate(state.email, state.pwd);
      //emit(state.copyWith(formStatus: SubmittingSuccess()));
      session.add(SessionLocalAuthenticationEvent(
          email: state.email, token: 'dfgdfgdfDFGdf'));
    } catch (e) {
      emit(state.copyWith(formStatus: SubmissionFailed(e as Exception)));
    }
  }

  void _loginGoogle(LoginGoogleEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(formStatus: ExternalLoginGoogle()));
    Future estaConectado = googleSignIn.isSignedIn();
    estaConectado.then((b) {
      if (b) {
        Future desconectar = googleSignIn.disconnect();
        desconectar.then((value) => googleSignIn.signIn());
      } else {
        googleSignIn.signIn();
      }
    });
  }
}
