import 'dart:convert';

import 'package:hnc/repository/service/custom_exceptions.dart';
import 'package:hnc/repository/service/hnc_service.dart';

import '../components/jwt_token.dart';

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

  Future<void> iniciarGoogle(String email) async {
    final token = JwtToken.generarToken(email, 'pass', 'google', 'iniciar');
    final resp = await service.iniciarGoogle(json.encode({'token': token}));
    if (resp == null) throw UnauthorizedException();
    service.setToken(resp["token"]);
  }

  Future<String> politica() async {
    final resp = await service.politica();
    return resp["politica"];
  }

  Future<void> recuperarPwd(String email) async {
    final token = JwtToken.generarToken(email, 'pass', 'local', 'recuperar');
    await service.recuperarPwd(json.encode({'token': token}));
  }
}
