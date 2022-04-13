import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: kIsWeb ? dotenv.get('GOOGLE_WEB') : dotenv.get('GOOGLE_ANDROID'),
  scopes: <String>[
    'email',
  ],
);

class GoogleHelper {
  GoogleHelper({required this.hncRepository, required this.session});

  final HncRepository hncRepository;
  final SessionBloc session;
  StreamSubscription<GoogleSignInAccount?>? subscripcion;

  void init() {
    subscripcion = _registraCambioGoogle();
  }

  StreamSubscription<GoogleSignInAccount?>? _registraCambioGoogle() {
    return googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount? account) {
        print("cambio en Google: $account");
        if (account != null) {
          //print(_currentUser?.email);
          String email = account.email;

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
          session.add(SessionGoogleSignInEvent(email: '', token: ''));
          // logout ?

        }
      },
    );
  }
}
