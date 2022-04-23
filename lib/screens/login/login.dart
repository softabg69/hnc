import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/login/login_bloc.dart';
import 'package:hnc/bloc/platform/platform_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/components/dialog.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../perfil/perfil.dart';
import '../varios/politica.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  Widget _loginField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    // If the button is pressed, return green, otherwise blue
                    // if (states.contains(MaterialState.pressed)) {
                    //   return Colors.green;
                    // }
                    // return Colors.blue;
                    if (state.datosCandidatos) {
                      return Theme.of(context).primaryColor;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                child: const Text('Login'),
              );
      },
    );
  }

  Widget _recuperarPassword(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigator.push<bool>(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return const Registro();
        //     },
        //   ),
        // ).then((value) {
        //   //print("Vuelta: $value");
        //   if (value != null && value) {
        //     _showDialog(context);
        //   }
        //   /*
        //   if (value != null && value) {
        //     final snackBar = SnackBar(
        //     content: const Text('Revisa el correo para activar la cuenta'),
        //   );
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   */
        // });
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
        // Navigator.push<bool>(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) {
        //       return const Registro();
        //     },
        //   ),
        // ).then((value) {
        //   //print("Vuelta: $value");
        //   if (value != null && value) {
        //     _showDialog(context);
        //   }
        //   /*
        //   if (value != null && value) {
        //     final snackBar = SnackBar(
        //     content: const Text('Revisa el correo para activar la cuenta'),
        //   );
        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
        //   */
        // });
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
                            border: Border.all(color: Colors.grey)),
                        child: Row(
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

  Widget _logo() {
    return BlocBuilder<PlatformBloc, PlatformState>(
      builder: (context, platform) {
        return GestureDetector(
          onTap: () {
            Dialogs.informacion(
                context,
                const Text('Info'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('appName: ${platform.appName}'),
                    Text('packageName: ${platform.packageName}'),
                    Text('version: ${platform.version}'),
                    Text('buildNumber: ${platform.buildNumber}'),
                    Text('buildSignature: ${platform.buildSignature}')
                  ],
                ));
          },
          child: Image.asset('assets/images/helpncare_logo.png'),
        );
      },
    );
  }

  Widget _loginForm(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: state.estado == EstadoLogin.autenticandoLocal ||
                  state.estado == EstadoLogin.autenticandoGoogle,
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.estado == EstadoLogin.googleError ||
                      state.estado == EstadoLogin.localError) {
                    _showSnackBar(context, state.mensajeError);
                    context.read<LoginBloc>().add(LoginEstadoInicial());
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
                        _loginField(),
                        _passwordField(),
                        const SizedBox(height: 20),
                        _loginButton(),
                        const SizedBox(height: 20),
                        // Text(
                        //   "o accede con",
                        //   style: TextStyle(
                        //       color: Theme.of(context).colorScheme.primary),
                        // ),
                        const SizedBox(height: 10.0),
                        google(),
                        // InkWell(
                        //   onTap: () {},
                        //   child: CircleAvatar(
                        //     radius: 25,
                        //     backgroundColor:
                        //         Theme.of(context).colorScheme.primary,
                        //     child: ClipRRect(
                        //       clipBehavior: Clip.antiAlias,
                        //       borderRadius: BorderRadius.circular(20),
                        //       child: Image.asset(
                        //         'assets/images/google_icon.png',
                        //         width: 40,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 15),
                        _recuperarPassword(context),
                        (kIsWeb
                            ? const SizedBox(height: 10)
                            : const SizedBox(height: 0)),
                        _registrate(context),
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          print("listener autenticado");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const Perfil(),
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocProvider(
          create: (context) => LoginBloc(
              hncRepository: context.read<HncRepository>(),
              session: context.read<SessionBloc>()),
          child: _loginForm(context),
        ),
      ),
    );
  }
}
