import 'package:hnc/components/configuracion.dart';

class Log {
  static void registra(String msg) {
    if (Environment().config!.esDesarrollo) {
      print(msg);
    }
  }
}
