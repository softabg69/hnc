import 'dart:convert';
import 'dart:typed_data';
import 'package:hnc/repository/models/categoria.dart';
import 'package:hnc/repository/models/contenido.dart';
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

  Future<List<Contenido>> getContenidos(
      List<int> idsCategorias, int dias, int? offset) async {
    offset ??= 0;
    final String categorias = json.encode(idsCategorias);
    final jsn = await service.getContenidos(categorias, dias, offset);
    return List<Contenido>.from(jsn.map((model) => Contenido.fromJson(model)))
        .toList();
  }

  Future<void> setGusta(String idContenido, bool gusta) async {
    final body = {};
    body['idContenido'] = idContenido;
    body['gusta'] = gusta;
    await service.setGusta(json.encode(body));
  }

  Future<Contenido> guardarContenido(
      String? idContenido,
      String? titulo,
      String? cuerpo,
      String? url,
      Uint8List? imagen,
      int modo,
      List<int> categorias) async {
    final body = json.encode({
      'idContenido': idContenido,
      'imagen': imagen,
      'titulo': titulo,
      'texto': cuerpo,
      'url': url,
      'modo': modo,
      'categorias': categorias
    });
    return Contenido.fromJson(await service.guardarContenido(body));
  }

  void cierra() {
    service.setToken('');
  }
}
