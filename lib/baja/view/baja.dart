import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/baja/bloc/baja_bloc.dart';
import 'package:helpncare/components/dialog.dart';

import '../../bloc/session/session_bloc.dart';
import '../../login/view/login.dart';

class Baja extends StatefulWidget {
  const Baja({Key? key}) : super(key: key);

  @override
  State<Baja> createState() => _BajaState();
}

class _BajaState extends State<Baja> {
  @override
  void didChangeDependencies() {
    context.read<BajaBloc>().add(BajaProcesar());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BajaBloc, BajaState>(
        listener: (context, state) async {
          if (state == BajaCompletada()) {
            await Dialogs.informacion(context, const Text('Baja'),
                const Text('La baja se ha procesado correctamente'));
            context.read<SessionBloc>().add(SessionClosing());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Login(),
              ),
            );
          } else if (state == BajaError()) {
            await Dialogs.informacion(
                context,
                const Text('Baja'),
                const Text(
                    'Se ha producido un error. La baja no se ha procesado.'));
            context.read<SessionBloc>().add(SessionClosing());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Login(),
              ),
            );
          }
        },
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Image.asset('assets/images/helpncare_logo.png'),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Procesando baja...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            const CircularProgressIndicator()
          ],
        )),
      ),
    );
  }
}
