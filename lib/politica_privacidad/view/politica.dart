import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/bloc/request_status.dart';
import 'package:helpncare/widgets/error.dart';
//import 'package:helpncare/widgets/session.dart';
import 'package:helpncare/widgets/una_columna.dart';
import '../bloc/politica_bloc.dart';
import '../../repository/hnc_repository.dart';

class Politica extends StatefulWidget {
  const Politica({Key? key}) : super(key: key);
  static const routeName = "/politicaprivacidad";

  @override
  _PoliticaState createState() => _PoliticaState();
}

class _PoliticaState extends State<Politica> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PoliticaBloc(
        hncRepository: context.read<HncRepository>(),
      )..add(PoliticaRequestDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Política de privacidad'),
        ),
        body: BlocBuilder<PoliticaBloc, PoliticaState>(
          builder: (context, state) {
            return state.requestStatus is RequestSubmitting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : state.requestStatus is RequestFailed
                    ? const Error()
                    : SafeArea(
                        child: SingleChildScrollView(
                          child: UnaColumna(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(state.texto),
                              ),
                            ),
                          ),
                        ),
                      );
          },
        ),
      ),
    );
  }
}
