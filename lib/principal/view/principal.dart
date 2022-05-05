import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/principal/widgets/drawer_principal.dart';
import 'package:hnc/repository/hnc_repository.dart';
import '../bloc/principal_bloc.dart';
import '../widgets/app_bar_principal.dart';

//typedef DrawerCallback = void Function(bool isOpened);

class Principal extends StatelessWidget {
  Principal({Key? key}) : super(key: key);

  void _onDrawerChanged(bool isOpened) {
    print("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPrincipal(),
      onDrawerChanged: (bool isOpen) {
        if (isOpen) {
          context.read<PrincipalBloc>().add(PrincipalDrawerOpen());
        } else {
          context.read<PrincipalBloc>().add(PrincipalDrawerClose());
        }
      },
      body: BlocProvider<ContenidoBloc>(
        create: (context) => ContenidoBloc(
            hncRepository: context.read<HncRepository>(),
            session: context.read<SessionBloc>())
          ..add(ContenidoCargarEvent()),
        child: const CustomScrollView(
          slivers: [
            AppBarPrincipal(),
          ],
        ),
      ),
    );
  }
}
