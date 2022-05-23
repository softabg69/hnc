import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/app_bloc_observer.dart';
import 'package:hnc/bloc/memoria_contenido.dart/bloc/memoria_contenido_bloc.dart';
import 'package:hnc/bloc/platform/platform_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/components/configuracion.dart';
//import 'package:hnc/components/dialog.dart';
import 'package:hnc/contenido/bloc/contenido_bloc.dart';
import 'package:hnc/enumerados.dart';
import 'package:hnc/perfil/bloc/perfil_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:hnc/repository/service/hnc_service.dart';
import 'package:hnc/stories/bloc/stories_bloc.dart';
import 'package:hnc/user_stories/bloc/user_stories_bloc.dart';

import 'compartido/views/compartido.dart';
//import 'components/log.dart';
import 'login/view/login.dart';

String urlInicio = "";
void main() {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
  if (kIsWeb) {
    urlInicio = Uri.base.toString(); //get complete url
  }
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      Environment().initConfig(environment);
      runApp(const AppState());
    },
    blocObserver: AppBlocObserver(),
  );
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<HncRepository>(
      create: (context) => HncRepository(service: HncService()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                SessionBloc(hncRepository: context.read<HncRepository>())
                  ..add(SessionInitEvent()),
          ),
          BlocProvider(
            create: (context) =>
                PlatformBloc(hncRepository: context.read<HncRepository>())
                  ..add(PlatformLoadEvent()),
          ),
          BlocProvider(
              create: (context) => ContenidoBloc(
                  hncRepository: context.read<HncRepository>(),
                  session: context.read<SessionBloc>())),
          BlocProvider(
              create: (context) => StoriesBloc(
                  session: context.read<SessionBloc>(),
                  hncRepository: context.read<HncRepository>())),
          BlocProvider(create: (context) => MemoriaContenidoBloc()),
          // BlocProvider(
          //   create: (context) => PrincipalBloc(
          //       hncRepository: context.read<HncRepository>(),
          //       session: context.read<SessionBloc>()),
          // ),
          BlocProvider(
            create: (context) => PerfilBloc(
              sesionBloc: context.read<SessionBloc>(),
              hncRepository: context.read<HncRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => UserStoriesBloc(
                hncRepository: context.read<HncRepository>(),
                session: context.read<SessionBloc>()),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }
}

Map<int, Color> colorCodes = {
  50: const Color.fromRGBO(147, 205, 72, .1),
  100: const Color.fromARGB(51, 98, 110, 83),
  200: const Color.fromRGBO(147, 205, 72, .3),
  300: const Color.fromRGBO(147, 205, 72, .4),
  400: const Color.fromRGBO(147, 205, 72, .5),
  500: const Color.fromRGBO(147, 205, 72, .6),
  600: const Color.fromRGBO(147, 205, 72, .7),
  700: const Color.fromRGBO(147, 205, 72, .8),
  800: const Color.fromRGBO(147, 205, 72, .9),
  900: const Color.fromRGBO(147, 205, 72, 1),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _mantenimiento(String mensaje) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Image.asset('assets/images/helpncare_logo.png'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                mensaje,
                style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helpncare bloc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xFF2B73B6, colorCodes),
        ).copyWith(secondary: const Color(0xFF99BE16)),
        fontFamily: 'Roboto',
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      ),
      home: BlocBuilder<PlatformBloc, PlatformState>(builder: (context, state) {
        if (kIsWeb) {
          return urlInicio.contains("#/compartido?token=")
              ? Compartido(
                  url: urlInicio,
                )
              : const Login();
        } else if (state is AplicacionBloqueada) {
          return _mantenimiento(state.msg);
        } else if (state.estado == EstadoPlatform.cargando) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Image.asset('assets/images/helpncare_logo.png'),
              ),
            ),
          );
        } else {
          if (state.resultadoVersion == ResultadoComparaVersion.imcompatible) {
            return _mantenimiento(
                'La versión que tiene instalada es demasiado antigua. Debe actualizar a una nueva versión para seguir utilizando Helpncare.');
          } else if (state.resultadoVersion ==
              ResultadoComparaVersion.nuevaVersionDisponible) {
            return const Login(
              nuevaVersionDisponible: true,
            );
          } else {
            return const Login();
          }
        }
      }),
    );
  }
}
