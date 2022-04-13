import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hnc/bloc/session/session_bloc.dart';
import 'package:hnc/repository/hnc_repository.dart';
import 'package:hnc/repository/service/hnc_service.dart';

import 'screens/login/login.dart';

Future main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("dotEnv error: $e");
  }
  runApp(const AppState());
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
        ],
        child: const MyApp(),
      ),
    );
  }
}

Map<int, Color> colorCodes = {
  50: const Color.fromRGBO(147, 205, 72, .1),
  100: const Color.fromRGBO(147, 205, 72, .2),
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helpncare bloc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(0xFF2B73B6, colorCodes),
        ).copyWith(secondary: const Color(0xFF99BE16)),
        fontFamily: 'Roboto',
      ),
      home: Login(),
      routes: {},
    );
  }
}
