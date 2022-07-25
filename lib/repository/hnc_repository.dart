import 'dart:convert';
import 'dart:typed_data';
import 'package:helpncare/repository/models/categoria.dart';
import 'package:helpncare/repository/models/contenido.dart';
import 'package:helpncare/repository/models/perfil.dart';
import 'package:helpncare/repository/models/usuario_story.dart';
import 'package:helpncare/repository/service/custom_exceptions.dart';
import 'package:helpncare/repository/service/hnc_service.dart';

import '../components/jwt_token.dart';
import '../components/log.dart';
import 'models/version.dart';

class HncRepository {
  const HncRepository({
    required this.service,
  });

  final HncService service;

  Future<String> authenticate(String email, String pwd) async {
    final token = JwtToken.generarToken(email, pwd, 'local', 'autenticar');
    final resp = await service.autenticar(json.encode({'token': token}));
    if (resp == null || resp['token'].toString().isEmpty) {
      throw UnauthorizedException();
    }
    service.setToken(resp["token"]);
    return resp["avatar"];
  }

  Future<String> iniciarGoogle(String email, String urlAvatar) async {
    final token = JwtToken.generarToken(email, 'pass', 'google', 'iniciar');
    final resp = await service
        .iniciarGoogle(json.encode({'token': token, 'urlAvatar': urlAvatar}));
    if (resp == null) throw UnauthorizedException();
    service.setToken(resp["token"]);
    return resp["avatar"];
  }

  Future<String> iniciarApple(String email) async {
    final token = JwtToken.generarToken(email, 'pass', 'apple', 'iniciar');
    final resp = await service.iniciarApple(json.encode({'token': token}));
    if (resp == null) throw UnauthorizedException();
    service.setToken(resp["token"]);
    return 'OK';
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

  Future<Perfil> getPerfil() async {
    final json = await service.getPerfil();
    Log.registra('Respuesta getPerfil: $json');

    return Perfil(
        nickname: json['nickname'],
        categorias: List<Categoria>.from(
            json['categorias'].map((model) => Categoria.fromJson(model))));
  }

  Future<String> actualizarPerfil(
      List<int> categorias, Uint8List? avatar, String nickname) async {
    final body = <String, dynamic>{};
    body['categorias'] = categorias;
    body['nickname'] = nickname;
    if (avatar != null && avatar.isNotEmpty) body['avatar'] = avatar;
    Log.registra('body actualizar: $body');
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

  Future<List<Contenido>> getStoriesUsuario(
      String idUsuario, List<int> idsCategorias, int dias, int? offset) async {
    offset ??= 0;
    final String categorias = json.encode(idsCategorias);
    final jsn =
        await service.getStoriesUsuario(idUsuario, categorias, dias, offset);
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

  Future<void> eliminarContenido(String idContenido) async {
    final body = {};
    body['idContenido'] = idContenido;
    await service.eliminarContenido(json.encode(body));
  }

  Future<void> desconectar() async {
    await service.desconectar();
  }

  void cierra() {
    service.setToken('');
  }

  Future<List<UsuarioStory>> getStories(List<int> categorias, int dias) async {
    final stories = await service.getStories(-dias, json.encode(categorias));
    return List<UsuarioStory>.from(
        stories.map((model) => UsuarioStory.fromJson(model))).toList();
  }

  Future<Contenido> getContenidoCompartido(String idContenido) async {
    final jsn = await service.getContenidoCompartido(idContenido);
    return Contenido.fromJson(jsn);
  }

  Future<Version> getVersion() async {
    final jsn = await service.getVersion();
    return Version.fromJson(jsn);
  }

  Future denunciaContenido(String idContenido) async {
    final body = {};
    body['idContenido'] = idContenido;
    await service.denunciarContenido(json.encode(body));
  }

  Future validaCredencialApple(String autorizationCode) async {
    await service.validarApple(autorizationCode);
  }
}
