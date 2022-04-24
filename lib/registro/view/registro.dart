import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialog.dart';
import '../../repository/hnc_repository.dart';
import '../../widgets/logo.dart';
import '../bloc/registro_bloc.dart';

class Registro extends StatelessWidget {
  Registro({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  Widget _emailField() {
    return BlocBuilder<RegistroBloc, RegistroState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            icon: Icon(Icons.person),
          ),
          validator: (_) => state.isValidEmail ? null : 'Email no válido',
          onChanged: (value) => context.read<RegistroBloc>().add(
                EmailChangedEvent(email: value),
              ),
        );
      },
    );
  }

  Widget _pass1Field() {
    return BlocBuilder<RegistroBloc, RegistroState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            icon: Icon(Icons.security),
          ),
          validator: (valuue) =>
              state.isPass1Valid ? null : 'Contraseña no válida',
          onChanged: (value) => context.read<RegistroBloc>().add(
                Pass1ChangedEvent(pass: value),
              ),
        );
      },
    );
  }

  Widget _pass2Field() {
    return BlocBuilder<RegistroBloc, RegistroState>(
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Repetir contraseña',
            icon: Icon(Icons.security),
          ),
          validator: (valuue) =>
              state.isPass2Valid ? null : 'Contraseña no válida',
          onChanged: (value) => context.read<RegistroBloc>().add(
                Pass2ChangedEvent(pass: value),
              ),
        );
      },
    );
  }

  Widget _enviarButton() {
    return BlocBuilder<RegistroBloc, RegistroState>(
      builder: (context, state) {
        return state.estado == EstadoRegistro.enviando
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (state.datosValidos) {
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<RegistroBloc>().add(RegistroEnviar());
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (state.datosValidos) {
                      return Theme.of(context).primaryColor;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                child: const Text('Registrar'),
              );
      },
    );
  }

  Widget _registroForm(BuildContext context) {
    return BlocBuilder<RegistroBloc, RegistroState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: state.estado == EstadoRegistro.enviando,
              child: BlocListener<RegistroBloc, RegistroState>(
                listener: (context, state) {
                  if (state.estado == EstadoRegistro.error) {
                    Dialogs.snackBar(
                        context: context,
                        content: const Text(
                            'Error al registrar. Error en la conexión o la cuenta ya existe.'),
                        color: Colors.red);
                    context.read<RegistroBloc>().add(RegistroTerminado());
                  } else if (state.estado == EstadoRegistro.enviado) {
                    Dialogs.snackBar(
                        context: context,
                        content: const Text(
                            'Registro correcto. Revisa tu correo para completar el registro.'),
                        color: Colors.green);
                    Navigator.pop(context);
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
                        const Logo(),
                        const SizedBox(
                          height: 10,
                        ),
                        _emailField(),
                        _pass1Field(),
                        _pass2Field(),
                        const SizedBox(height: 20),
                        _enviarButton(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: BlocProvider(
        create: (context) => RegistroBloc(
          hncRepository: context.read<HncRepository>(),
        ),
        child: _registroForm(context),
      ),
    );
  }
}
