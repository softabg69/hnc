import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpncare/bloc/session/session_bloc.dart';
import 'package:helpncare/principal/bloc/principal_bloc.dart';
import 'package:helpncare/principal/widgets/categoria_horizontal.dart';

import '../../components/log.dart';
import '../../enumerados.dart';

class DrawerPrincipal extends StatelessWidget {
  const DrawerPrincipal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      key: UniqueKey(),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              key: UniqueKey(),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset('assets/images/helpncare_logo.png'),
                ),
              ),
            ),
            SliverToBoxAdapter(
              key: UniqueKey(),
              child: Card(child: rangoFechas(context)),
            ),
            SliverFillRemaining(
              key: UniqueKey(),
              child: filtroCategorias(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget rangoFechas(BuildContext context) {
    //final _contenidoProvider = Provider.of<ContenidoProvider>(context);

    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Filtrar por fechas',
              ),
            ),
            RadioListTile<FiltroFechas>(
              title: const Text('Últimos 5 días'),
              value: FiltroFechas.ultimos5dias,
              groupValue: state.dias,
              onChanged: (FiltroFechas? value) {
                context
                    .read<SessionBloc>()
                    .add(SessionCambioDias(FiltroFechas.ultimos5dias));
                //_contenidoProvider.setDias(context, FiltroFechas.cincoDias);
                //Navigator.pop(context);
              },
            ),
            RadioListTile<FiltroFechas>(
              title: const Text('Todo'),
              value: FiltroFechas.todos,
              groupValue: state.dias,
              onChanged: (FiltroFechas? value) {
                context
                    .read<SessionBloc>()
                    .add(SessionCambioDias(FiltroFechas.todos));

                //_contenidoProvider.setDias(context, FiltroFechas.todo);
                //Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget filtroCategorias(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        Log.registra('categorias session: ${state.categoriasUsuario.length}');
        return ListView.builder(
          key: UniqueKey(),
          scrollDirection: Axis.vertical,
          itemCount: state.categoriasUsuario.length,
          itemBuilder: (BuildContext context, int index) {
            final categoria = state.categoriasUsuario[index];
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CategoriaHorizontal(
                  key: Key('C${categoria.id}'),
                  categoria: categoria,
                  seleccionada: state.filtroCategorias.contains(categoria.id),
                  callback: (c) {
                    context
                        .read<SessionBloc>()
                        .add(SessionCambioFiltroCategoria(categoria.id));
                    Log.registra('Categoria filtro cambiada: $c');
                  },
                )
                // ChangeNotifierProvider.value(
                //   value: cats[index],
                //   child: const CategoriaHorizontal(),
                // ),
                );
          },
        );
      },
    );
  }
}
