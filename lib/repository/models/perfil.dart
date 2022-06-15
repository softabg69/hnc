import 'package:helpncare/repository/models/categoria.dart';

class Perfil {
  Perfil({required this.categorias, this.nickname});

  List<Categoria> categorias;
  String? nickname;
}
