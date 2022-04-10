import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/login/form_submission_status.dart';
import 'package:hnc/bloc/login/login_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';

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
              state.isValidPwd ? null : 'Password demasiado corto',
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
        return state.formStatus is FormSubmitting
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(LoginButtonPressEvent());
                  }
                },
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
        text: const TextSpan(
          style: TextStyle(fontSize: 16),
          children: <TextSpan>[
            TextSpan(text: '¿Olvidaste la contraseña?  '),
            TextSpan(
              text: 'Recuperar',
              style: TextStyle(fontWeight: FontWeight.bold),
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
        text: const TextSpan(
          style: TextStyle(fontSize: 16),
          children: <TextSpan>[
            TextSpan(text: '¿No tienes cuenta?  '),
            TextSpan(
              text: 'Regístrate',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: state.formStatus is FormSubmitting,
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
                      Image.asset('/images/helpncare_logo.png'),
                      const SizedBox(
                        height: 10,
                      ),
                      _loginField(),
                      _passwordField(),
                      const SizedBox(height: 20),
                      _loginButton(),
                      const SizedBox(height: 20),
                      const Text(
                        "o accede con",
                        style: TextStyle(),
                      ),
                      const SizedBox(height: 10.0),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              '/images/google_icon.png',
                              width: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      _recuperarPassword(context),
                      const SizedBox(height: 15),
                      _registrate(context)
                    ],
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
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          hncRepository: context.read<HncRepository>(),
        ),
        child: _loginForm(context),
      ),
    );
  }
}
