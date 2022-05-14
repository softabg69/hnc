import 'package:flutter/material.dart';
import 'package:hnc/bloc/session/cierre_sesion.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/contenido/view/contenido.dart';
import 'package:hnc/principal/widgets/drawer_principal.dart';
import '../../components/log.dart';
import '../widgets/app_bar_principal.dart';

//typedef DrawerCallback = void Function(bool isOpened);

class Principal extends StatefulWidget {
  const Principal({Key? key, required this.contenidoBloc}) : super(key: key);

  final ContenidoBloc contenidoBloc;
  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.contenidoBloc.add(ContenidoCargarEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      Log.registra('alcanzado final contenidos');
      widget.contenidoBloc.add(ContenidoCargarEvent());
    }
  }

  bool get _isBottom {
    //Log.registra('isBottom');
    if (!_scrollController.hasClients) return false;
    //Log.registra('isBottom 2');
    final maxScroll = _scrollController.position.maxScrollExtent;
    //Log.registra('maxScroll: $maxScroll');
    final currentScroll = _scrollController.offset;
    //Log.registra('currentScroll: $currentScroll');
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return CierreSesion(
      child: Scaffold(
        drawer: const DrawerPrincipal(),
        backgroundColor: Colors.grey,
        // onDrawerChanged: (bool isOpen) {
        //   if (isOpen) {
        //     context.read<PrincipalBloc>().add(PrincipalDrawerOpen());
        //   } else {
        //     context.read<PrincipalBloc>().add(PrincipalDrawerClose());
        //   }
        // },
        body: CustomScrollView(
          controller: _scrollController,
          slivers: const [
            AppBarPrincipal(),
            Contenido(),
          ],
        ),
      ),
    );
  }
}
