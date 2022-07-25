import 'dart:async';
//import 'dart:io' show Platform;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:helpncare/perfil/bloc/perfil_bloc.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//import 'package:the_apple_sign_in/scope.dart';
import '../../components/log.dart';
import '../../enumerados.dart';
import '../../registro/view/registro.dart';
import '../bloc/login_bloc.dart';
import 'package:helpncare/bloc/platform/platform_bloc.dart';
import 'package:helpncare/bloc/session/session_bloc.dart';
import 'package:helpncare/components/dialog.dart';
import 'package:helpncare/repository/hnc_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:helpncare/recuperar_password/view/recuperar_pwd.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../../perfil/view/perfil.dart';
import '../../politica_privacidad/view/politica.dart';
//import 'package:html_shim.dart' if (dart.library.html) 'dart:html' show window;

class Login extends StatefulWidget {
  const Login({Key? key, this.nuevaVersionDisponible = false})
      : super(key: key);

  final bool nuevaVersionDisponible;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  bool navegado = false;
  bool mostradoSnackBar = false;
  bool procesadasCredenciales = false;
  bool recordar = false;
  bool isIOS = false;
  final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkLoggedInState();

    TheAppleSignIn.onCredentialRevoked?.listen((_) {
      Log.registra("Credentials revoked");
    });
  }

  @override
  void didChangeDependencies() {
    isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    context.read<LoginBloc>().add(LoginCheckAppleEvent());
    super.didChangeDependencies();
  }

  // void logIn() async {
  //   final AuthorizationResult result = await TheAppleSignIn.performRequests([
  //     const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   ]);
  //   Log.registra('result.status: ${result.status}');
  //   Log.registra('result credential: ${result.credential}');
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:

  //       // Store user ID
  //       await const FlutterSecureStorage()
  //           .write(key: "userId", value: result.credential?.user);
  //       await const FlutterSecureStorage()
  //           .write(key: "email", value: result.credential?.email);
  //       //checkLoggedInState();
  //       // Navigate to secret page (shhh!)
  //       //Log.registra('Navegar a página secreta: ${result.credential?.email}');

  //       // Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       //     builder: (_) => AfterLoginPage(credential: result.credential)));
  //       break;

  //     case AuthorizationStatus.error:
  //       Log.registra("Sign in failed: ${result.error?.localizedDescription}");
  //       setState(() {
  //         //errorMessage = "Sign in failed";
  //       });
  //       break;

  //     case AuthorizationStatus.cancelled:
  //       Log.registra('User cancelled');
  //       break;
  //   }
  // }

  // void checkLoggedInState() async {
  //   final userId = await const FlutterSecureStorage().read(key: "userId");
  //   Log.registra('userId: $userId');
  //   if (userId == null) {
  //     Log.registra("No stored user ID");
  //     return;
  //   }

  //   final credentialState = await TheAppleSignIn.getCredentialState(userId);
  //   Log.registra('status: ${credentialState.status}');
  //   switch (credentialState.status) {
  //     case CredentialStatus.authorized:
  //       Log.registra("getCredentialState returned authorized");
  //       final email = await const FlutterSecureStorage().read(key: "email");
  //       Log.registra('Email***: $email');
  //       //context.read<SessionBloc>().add(SessionAppleSignInEvent(email: email!));

  //       context
  //           .read<LoginBloc>()
  //           .add(LoginAppleEvent(email: 'softabg@gmail.com'));
  //       break;

  //     case CredentialStatus.error:
  //       Log.registra(
  //           "getCredentialState returned an error: ${credentialState.error?.localizedDescription}");
  //       break;

  //     case CredentialStatus.revoked:
  //       Log.registra("getCredentialState returned revoked");
  //       break;

  //     case CredentialStatus.notFound:
  //       Log.registra("getCredentialState returned not found");
  //       break;

  //     case CredentialStatus.transferred:
  //       Log.registra("getCredentialState returned not transferred");
  //       break;
  //   }
  // }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        Log.registra('emailField: ${state.email}');
        return TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            icon: Icon(Icons.person),
          ),
          validator: (_) => state.isValidEmail ? null : 'Email no válido',
          onChanged: (value) => context.read<LoginBloc>().add(
                EmailChangedEvent(email: value),
              ),
        );
      },
    );
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          controller: _pwdController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            icon: Icon(Icons.security),
          ),
          validator: (valuue) =>
              state.isValidPwd ? null : 'Contraseña no válida',
          onChanged: (value) => context.read<LoginBloc>().add(
                PasswordChangedEvent(pwd: value),
              ),
        );
      },
    );
  }

  Widget _recordar() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Checkbox(
              value: recordar,
              onChanged: (b) {
                context
                    .read<LoginBloc>()
                    .add(LoginRecordarEvent(recordar: b ?? false));
                setState(() {
                  recordar = b ?? false;
                });
              }),
          const Text('recordar credenciales')
        ],
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.estado == EstadoLogin.autenticandoLocal
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (state.datosCandidatos) {
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<LoginBloc>().add(LoginButtonPressEvent());
                    }
                  }
                },
                // style: ButtonStyle(
                //   backgroundColor: MaterialStateProperty.resolveWith((states) {
                //     // If the button is pressed, return green, otherwise blue
                //     // if (states.contains(MaterialState.pressed)) {
                //     //   return Colors.green;
                //     // }
                //     // return Colors.blue;
                //     if (state.datosCandidatos) {
                //       return Theme.of(context).primaryColor;
                //     } else {
                //       return Colors.grey;
                //     }
                //   }),
                // ),
                child: const Text('Login'),
              );
      },
    );
  }

  Widget _recuperarPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RecoverPassword();
        }));
      },
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: '¿Olvidaste la contraseña?  ',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            TextSpan(
              text: 'Recuperar',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registrate(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Registro();
            },
          ),
        );
      },
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: '¿No tienes cuenta?  ',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            TextSpan(
              text: 'Regístrate',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget google() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Center(
          child: state.estado == EstadoLogin.autenticandoGoogle
              ? const CircularProgressIndicator()
              : state.estado == EstadoLogin.googleError
                  ? const Text(
                      'Error',
                      style: TextStyle(color: Colors.red),
                    )
                  : InkWell(
                      onTap: () {
                        context.read<LoginBloc>().add(LoginGoogleEvent());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        child: Row(
                            mainAxisSize:
                                !isIOS ? MainAxisSize.min : MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/images/google_icon.png',
                                  width: 30,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text('Identifícate con Google'),
                              const SizedBox(
                                width: 10,
                              ),
                            ]),
                      ),
                    ),
        );
      },
    );
  }

  Widget _politica(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        text: 'Política de privacidad',
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Politica(),
              ),
            );
          },
      ),
    );
  }

  Widget _textInfo(PlatformState state) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          const TextSpan(text: 'AppName: '),
          TextSpan(
              text: state.appName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: '  PackageName: '),
          TextSpan(
              text: state.packageName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: '  BuildNumbre: '),
          TextSpan(
              text: state.buildNumber,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const TextSpan(text: '  Signature: '),
          TextSpan(
              text: state.buildSignature,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _logo() {
    return BlocBuilder<PlatformBloc, PlatformState>(
      builder: (context, platform) {
        return GestureDetector(
          onTap: () {
            Dialogs.snackBar(
                context: context,
                content: _textInfo(platform),
                color: Theme.of(context).primaryColor);
          },
          child: Image.asset('assets/images/helpncare_logo.png'),
        );
      },
    );
  }

  Widget _loginApple() {
    Log.registra('kisweb: $kIsWeb');
    return FutureBuilder<bool>(
        future: _isAvailableFuture,
        builder: (context, isAvailableSnapshot) {
          if (!isAvailableSnapshot.hasData) {
            return const Text('Loading...');
          }
          return !isAvailableSnapshot.data!
              ? const SizedBox(
                  height: 0,
                )
              : BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  return state.estado == EstadoLogin.autenticandoApple
                      ? const CircularProgressIndicator()
                      : AppleSignInButton(onPressed: () {
                          context.read<LoginBloc>().add(LoginApple());
                        }
                          //logIn,
                          );
                  // : SignInWithAppleButton(
                  //     onPressed: () async {
                  //       context.read<LoginBloc>().add(LoginAppleEvent());

                  //       // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                  //       // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                  //     },
                  //   );
                });
        });
  }

  Widget _loginForm(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.estado == EstadoLogin.solicitudCierre) {
          context.read<LoginBloc>().add(LoginClose());
        }
        return Center(
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: state.estado == EstadoLogin.autenticandoLocal ||
                  state.estado == EstadoLogin.autenticandoGoogle ||
                  state.estado == EstadoLogin.autenticandoApple,
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.estado == EstadoLogin.googleError ||
                      state.estado == EstadoLogin.appleError ||
                      state.estado == EstadoLogin.localError) {
                    Log.registra(
                        'login error: ${state.mensajeError} ${(state.mensajeError == 'Petición no válida')}');
                    Dialogs.snackBar(
                        context: context,
                        content: Text(state.mensajeError.isEmpty
                            ? 'Se ha producido un error'
                            : state.mensajeError == 'Petición no válida'
                                ? 'Credenciales incorrectas'
                                : state.mensajeError),
                        color: Colors.red);
                    context.read<LoginBloc>().add(LoginProcesadoError());
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        _logo(),
                        const SizedBox(
                          height: 10,
                        ),
                        _emailField(),
                        _passwordField(),
                        const SizedBox(height: 20),
                        _recordar(),
                        const SizedBox(height: 20),
                        _loginButton(),
                        const SizedBox(height: 20),
                        google(),
                        const SizedBox(height: 15),
                        kIsWeb
                            ? const SizedBox(
                                height: 0,
                              )
                            : isIOS
                                ? _loginApple()
                                : const SizedBox(
                                    height: 0,
                                  ),
                        kIsWeb
                            ? const SizedBox(
                                height: 0,
                              )
                            : isIOS
                                ? const SizedBox(height: 15)
                                : const SizedBox(
                                    height: 0,
                                  ),
                        _recuperarPassword(context),
                        (kIsWeb
                            ? const SizedBox(height: 10)
                            : const SizedBox(height: 0)),
                        _registrate(context),
                        kIsWeb
                            ? const SizedBox(height: 20)
                            : const SizedBox(height: 0),
                        kIsWeb
                            ? RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text:
                                      'Usamos cookies para asegurar que te damos la mejor experiencia en nuestra web. Si continúas usando este sitio, asumiremos que estás de acuerdo con ello.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              )
                            : const SizedBox(
                                height: 0,
                              ),
                        const SizedBox(height: 20),
                        _politica(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Timer scheduleTimeout([int milliseconds = 1000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    Dialogs.snackBar(
        context: context,
        color: Colors.green,
        content: const Text('Hay una nueva versión de Helpncare.'));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nuevaVersionDisponible && !mostradoSnackBar) {
      mostradoSnackBar = true;
      scheduleTimeout(1 * 1000); // 5 seconds.
    }
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state.isAuthenticated && !navegado) {
          navegado = true;
          context.read<PerfilBloc>().add(PerfilCargarEvent());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const Perfil(),
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.estado == EstadoLogin.cargadasCredenciales &&
                !procesadasCredenciales) {
              procesadasCredenciales = true;
              _emailController.text = state.email;
              _pwdController.text = state.pwd;
              setState(() {
                Log.registra('setState recordar: ${state.recordar}');
                recordar = state.recordar;
              });
            }
          },
          child: _loginForm(context),
        ),
      ),
    );
  }
}
