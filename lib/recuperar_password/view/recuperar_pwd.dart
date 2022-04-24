import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/log.dart';
import '../../repository/hnc_repository.dart';
import '../../widgets/logo.dart';
import '../bloc/recuperar_password_bloc.dart';
import '../../components/dialog.dart';

class RecoverPassword extends StatelessWidget {
  RecoverPassword({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  Future<bool> _volverLogin(BuildContext context) async {
    Log.registra('volver');
    Navigator.pop(context);
    return true;
  }

  Widget _emailField() {
    return BlocBuilder<RecuperarPasswordBloc, RecuperarPasswordState>(
      builder: (context, state) {
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Email',
            icon: Icon(Icons.person),
          ),
          validator: (_) => state.isValidEmail ? null : 'Email no válido',
          onChanged: (value) => context.read<RecuperarPasswordBloc>().add(
                RecuperarPwdEmailCambiado(email: value),
              ),
        );
      },
    );
  }

  Widget _enviarButton() {
    return BlocBuilder<RecuperarPasswordBloc, RecuperarPasswordState>(
      builder: (context, state) {
        return state.estado == EstadoRecuperarPwd.enviandoSolicitud
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  if (state.isValidEmail) {
                    if (_formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context
                          .read<RecuperarPasswordBloc>()
                          .add(RecuperarPwdSolicitado());
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (state.isValidEmail) {
                      return Theme.of(context).primaryColor;
                    } else {
                      return Colors.grey;
                    }
                  }),
                ),
                child: const Text('Enviar'),
              );
      },
    );
  }

  Widget _recuperarForm(BuildContext context) {
    return BlocBuilder<RecuperarPasswordBloc, RecuperarPasswordState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: state.estado == EstadoRecuperarPwd.enviandoSolicitud,
              child:
                  BlocListener<RecuperarPasswordBloc, RecuperarPasswordState>(
                listener: (context, state) {
                  Log.registra("listen recpwd: ${state.estado}");
                  if (state.estado == EstadoRecuperarPwd.error) {
                    Dialogs.snackBar(
                        context: context,
                        content: const Text(
                          'Se ha producido un error al intentar recuperar la contraseña',
                        ),
                        color: Colors.red);
                  } else if (state.estado ==
                      EstadoRecuperarPwd.solicitudEnviada) {
                    Dialogs.snackBar(
                        context: context,
                        content: const Text(
                            'Revisa tu correo para recuperar la contraseña'),
                        color: Colors.green,
                        callback: _volverLogin(context));
                    context
                        .read<RecuperarPasswordBloc>()
                        .add(RecuperarPwdTerminado());
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
                        const SizedBox(height: 20),
                        _enviarButton(),
                        const SizedBox(height: 20),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
      ),
      body: BlocProvider(
        create: ((context) => RecuperarPasswordBloc(
              hncRepository: context.read<HncRepository>(),
            )),
        child: _recuperarForm(context),
      ),
    );
  }
}
