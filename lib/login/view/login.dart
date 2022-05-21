import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/perfil/bloc/perfil_bloc.dart';
import '../../enumerados.dart';
import '../../registro/view/registro.dart';
import '../bloc/login_bloc.dart';
import 'package:hnc/bloc/platform/platform_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/components/dialog.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hnc/recuperar_password/view/recuperar_pwd.dart';

import '../../perfil/view/perfil.dart';
import '../../politica_privacidad/view/politica.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool navegado = false;

  Widget _emailField() {
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
                            mainAxisSize: MainAxisSize.min,
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
        if (state.estado == EstadoLogin.solicitudCierre) {
          context.read<LoginBloc>().add(LoginClose());
        }
        return Center(
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: state.estado == EstadoLogin.autenticandoLocal ||
                  state.estado == EstadoLogin.autenticandoGoogle,
              child: BlocListener<LoginBloc, LoginState>(
                listener: (context, state) {
                  if (state.estado == EstadoLogin.googleError ||
                      state.estado == EstadoLogin.localError) {
                    Dialogs.snackBar(
                        context: context,
                        content: Text(state.mensajeError.isEmpty
                            ? 'Se ha producido un error'
                            : state.mensajeError),
                        color: Colors.red);
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
                        _loginButton(),
                        const SizedBox(height: 20),
                        google(),
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

  @override
  Widget build(BuildContext context) {
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
