import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/contenido/widgets/block_loader.dart';
import 'package:hnc/widgets/una_columna.dart';

import '../widgets/un_contenido.dart';

class Contenido extends StatefulWidget {
  const Contenido({Key? key}) : super(key: key);

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    //Log.registra('Redibujando Contenido');
    return BlocBuilder<ContenidoBloc, ContenidoState>(
      builder: (context, state) {
        //Log.registra('elementos: ${state.contenidos.length}');
        return state.estado == EstadoContenido.cargando &&
                state.contenidos.isEmpty
            ? const SliverToBoxAdapter(
                child: UnaColumna(
                  child: BlockLoader(),
                ),
              )
            : state.contenidos.isEmpty
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
                        (_, index) => index >= state.contenidos.length
                            ? const BlockLoader()
                            : BlocProvider.value(
                                value: context.read<ContenidoBloc>(),
                                child: UnContenido(
                                  index: index,
                                ),
                              ),
                        childCount: state.alcanzadoFinal
                            ? state.contenidos.length
                            : state.contenidos.length + 1),
                  );
      },
    );
  }
}
