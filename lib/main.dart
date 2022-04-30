import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hnc/bloc/app_bloc_observer.dart';
import 'package:hnc/bloc/platform/platform_bloc.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/components/configuracion.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:hnc/repository/service/hnc_service.dart';

import 'login/view/login.dart';

void main() {
  const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );
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
              create: (context) => SessionBloc()..add(SessionInitEvent())),
          BlocProvider(
            create: (context) => PlatformBloc()..add(PlatformLoadEvent()),
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
      ),
      home: Login(),
      //routes: {},
    );
  }
}
