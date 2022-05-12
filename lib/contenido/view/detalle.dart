import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/contenido/widgets/un_contenido.dart';

class Detalle extends StatelessWidget {
  const Detalle({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ContenidoBloc>(),
      child: BlocBuilder<ContenidoBloc, ContenidoState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              context.read<ContenidoBloc>().state.contenidos[index].titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          backgroundColor: Colors.grey,
          body: SingleChildScrollView(
            child: UnContenido(index: index, esDetalle: true),
          ),
        ),
      ),
    );
  }
}
