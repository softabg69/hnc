import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';

import '../widgets/un_contenido.dart';

class Contenido extends StatefulWidget {
  const Contenido({Key? key}) : super(key: key);

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContenidoBloc, ContenidoState>(
      builder: (context, state) {
        return state.contenidos.isEmpty
            ? SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Card(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(20),
                        child: const Text(
                            'No hay contenidos que cumplan el filtro actual'),
                      ),
                    ),
                  ),
                ),
              )
            : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      UnContenido(contenido: state.contenidos[index]),
                  childCount: state.contenidos.length,
                ),
              );
      },
    );
  }
}
