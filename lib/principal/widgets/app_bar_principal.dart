import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ayuda/view/ayuda.dart';
import '../../bloc/platform/platform_bloc.dart';
import '../../components/dialog.dart';

class AppBarPrincipal extends StatelessWidget {
  const AppBarPrincipal({Key? key}) : super(key: key);

  SliverAppBar appBar(BuildContext context) {
    return SliverAppBar(
      title: SizedBox(
        child: GestureDetector(
          child: Image.asset('assets/images/helpncare_logo.png'),
          onDoubleTap: () {
            final platform = context.read<PlatformBloc>();
            Dialogs.snackBar(
                context: context,
                content: Text('helpncare versión: ${platform.state.version}'),
                color: Theme.of(context).colorScheme.primary);
          },
        ),
        height: 50.0,
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Modificar filtros',
          );
        },
      ),
      expandedHeight: 70,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      actions: acciones(context),
    );
  }

  List<Widget> acciones(BuildContext context) {
    return <Widget>[
      GestureDetector(
        child: const Tooltip(
          message: 'Ayuda',
          child: Icon(Icons.help),
        ),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => Ayuda(),
            ),
          );
          //Navigator.pushNamed(context, Ayuda.routeName);
        },
      ),
      const SizedBox(
        width: 30.0,
      ),
      GestureDetector(
        child: const Tooltip(
          message: 'Acceder a tu perfil de usuario',
          child: Icon(Icons.person),
        ),
        //Image.asset('assets/images/icon_login.png'),
        onTap: () async {
          // var _perfilUsuario =
          //     Provider.of<PerfilUsuarioProvider>(context, listen: false);
          // _perfilUsuario.congelaCategoriasSeleccionadas();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (ctx) => Perfil(),
          //   ),
          // ).then((value) {
          //   if (_perfilUsuario.categoriasCambiadas()) {
          //     //print("categorias han cambiado");
          //     Provider.of<StoriesProvider>(context, listen: false)
          //         .cargarStories();
          //   }
        },
      ),
      const SizedBox(
        width: 30.0,
      ),
      GestureDetector(
        child: const Tooltip(
          message: 'Cerrar sesión',
          child: Icon(Icons.logout_outlined),
        ),
        //Image.asset('assets/images/icon_login.png'),
        onTap: () {
          // if (inicioExterno) {
          //   _cerrarSesion();
          // } else {
          //   token = '';
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => const Login(),
          //     ),
          //   );
          // }
        },
      ),
      const SizedBox(
        width: 10.0,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return appBar(context);
  }
}
