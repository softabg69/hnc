import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/memoria_contenido.dart/bloc/memoria_contenido_bloc.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/session/cierre_sesion.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
//import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/contenido/view/contenido.dart';
import 'package:hnc/principal/widgets/drawer_principal.dart';
import 'package:hnc/repository/hnc_repository.dart';
import '../../repository/models/contenido.dart' as model_contenido;
//import 'package:hnc/repository/hnc_repository.dart';
//import 'package:hnc/user_stories/bloc/user_stories_bloc.dart';
import '../../components/log.dart';
import '../../editor/bloc/editor_bloc.dart';
import '../../editor/views/editor.dart';
//import '../../stories/views/stories.dart';
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
      widget.contenidoBloc.add(const ContenidoCargarEvent());
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
        body: CustomScrollView(
          controller: _scrollController,
          slivers: const [
            AppBarPrincipal(),
            Contenido(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => BlocProvider.value(
                        value: context.read<ContenidoBloc>(),
                        child: BlocProvider(
                          create: ((context) => EditorBloc(
                              hncRepository: context.read<HncRepository>(),
                              session: context.read<SessionBloc>(),
                              memoriaContenido:
                                  context.read<MemoriaContenidoBloc>())),
                          child: Editor(
                            modo: 1,
                            contenido: model_contenido.Contenido(modo: 1),
                            guardar: (c) async {
                              context.read<ContenidoBloc>().add(
                                  const ContenidoCargarEvent(iniciar: true));
                              Log.registra('Después de crear nueva story');
                            },
                          ),
                        ),
                      ))),
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
          tooltip: 'Añadir nuevo contenido',
        ),
      ),
    );
  }
}
