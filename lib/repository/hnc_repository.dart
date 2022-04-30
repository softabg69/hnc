import 'dart:convert';
import 'dart:typed_data';
import 'package:hnc/repository/models/categoria.dart';
import 'package:hnc/repository/service/custom_exceptions.dart';
import 'package:hnc/repository/service/hnc_service.dart';

import '../components/jwt_token.dart';
import '../components/log.dart';

class HncRepository {
  const HncRepository({
    required this.service,
  });

  final HncService service;

  Future<void> authenticate(String email, String pwd) async {
    final token = JwtToken.generarToken(email, pwd, 'local', 'autenticar');
    final resp = await service.autenticar(json.encode({'token': token}));
    if (resp == null || resp['token'].toString().isEmpty) {
      throw UnauthorizedException();
    }
    service.setToken(resp["token"]);
  }

  Future<String> iniciarGoogle(String email, String urlAvatar) async {
    final token = JwtToken.generarToken(email, 'pass', 'google', 'iniciar');
    final resp = await service
        .iniciarGoogle(json.encode({'token': token, 'urlAvatar': urlAvatar}));
    if (resp == null) throw UnauthorizedException();
    service.setToken(resp["token"]);
    return resp["avatar"];
  }

  Future<String> politica() async {
    final resp = await service.politica();
    return resp["politica"];
  }

  Future<void> recuperarPwd(String email) async {
    final token = JwtToken.generarToken(email, 'pass', 'local', 'recuperar');
    await service.recuperarPwd(json.encode({'token': token}));
  }

  Future<void> registro(String email, String pwd) async {
    final token = JwtToken.generarToken(email, pwd, 'local', 'registrar');
    await service.registro(json.encode({'token': token}));
  }

  Future<List<Categoria>> getPerfil() async {
    final json = await service.getPerfil();
    return List<Categoria>.from(json.map((model) => Categoria.fromJson(model)));
  }

  Future<String> actualizarPerfil(
      List<int> categorias, Uint8List? avatar) async {
    final body = <String, dynamic>{};
    body['categorias'] = categorias;
    if (avatar != null && avatar.isNotEmpty) body['avatar'] = avatar;
    final res = await service.actualizarPerfil(json.encode(body));
    return res['avatar'];
  }
}
