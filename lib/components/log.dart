import 'package:helpncare/components/configuracion.dart';

class Log {
  static void registra(String msg) {
    if (Environment().config!.esDesarrollo) {
      print(msg);
    }
  }
}
