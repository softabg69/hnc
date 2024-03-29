//import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:helpncare/components/jwt_token.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../components/configuracion.dart';
import '../../components/log.dart';
import 'custom_exceptions.dart';

class HncService {
  HncService({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final Client _httpClient;
  String _token = '';

  void setToken(String token) {
    Log.registra("setToken serv: $token");
    _token = token;
  }

  void clearToken() {
    _token = '';
  }

  Uri _getUrl(String url) {
    Log.registra("URL: ${Environment().config!.baseUrlServicios}$url");
    return Uri.parse('${Environment().config!.baseUrlServicios}$url');
  }

  Future<dynamic> _get(String url, Map<String, String>? headers) async {
    Log.registra("get: $url");
    dynamic responseJson;
    try {
      final response = await _httpClient.get(_getUrl(url), headers: headers);
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
    return responseJson;
  }

  Future<dynamic> _post(
      String url, String body, Map<String, String>? headers) async {
    dynamic responseJson;
    try {
      final response =
          await _httpClient.post(_getUrl(url), body: body, headers: headers);
      Log.registra("_post: $response");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
    return responseJson;
  }

  Future<dynamic> _delete(
      String url, String body, Map<String, String>? headers) async {
    dynamic responseJson;
    try {
      final response =
          await _httpClient.delete(_getUrl(url), body: body, headers: headers);
      Log.registra("_delete: $response");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    Log.registra("response status: ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        //Log.registra("json: $responseJson");
        return responseJson;
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorizedException(response.body);
      case 500:
      default:
        throw FetchDataException(
            'Error en la comunicación con el servidor: ${response.statusCode}');
    }
  }

  // Future<List<Contenido>> getStories(List<int> categorias) async {
  //   return _request(
  //       url: 'stories',
  //       extra: {'categorias': jsonEncode(categorias)},
  //       resp: (s) {
  //         return List<Contenido>.from(
  //           json.decode(s).map((data) => Contenido.fromJson(data)),
  //         );
  //       });
  // }

  Map<String, String> get headersToken => <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'Bearer $_token'
      };

  Map<String, String> get headers => <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json'
      };

  Future<dynamic> politica() async {
    return await _get('/data/textolegal?id=1', null);
  }

  Future<dynamic> condiciones() async {
    return await _get('/data/textolegal?id=2', null);
  }

  Future<dynamic> cookies() async {
    return await _get('/data/textolegal?id=3', null);
  }

  Future<dynamic> autenticar(String token) async {
    Log.registra("autenticar: $token");
    return await _post('/data/autenticar', token, headers);
  }

  Future<dynamic> iniciarGoogle(String token) async {
    Log.registra("autenticar google: $token");
    return await _post('/data/iniciarGoogle', token, headers);
  }

  Future<dynamic> iniciarApple(String token) async {
    Log.registra("autenticar apple: $token");
    return await _post('/data/iniciarApple', token, headers);
  }

  Future<dynamic> recuperarPwd(String token) async {
    Log.registra("recuperarPwd");
    return await _post('/data/recuperarPwd', token, headers);
  }

  Future<dynamic> registro(String token) async {
    Log.registra("registro");
    return await _post('/data/registro', token, headers);
  }

  Future<dynamic> getPerfil() async {
    Log.registra('perfil');
    return await _get('/data/getPerfil', headersToken);
  }

  Future<dynamic> actualizarPerfil(String body) async {
    Log.registra('actualizarPerfil');
    return await _post('/data/actualizarPerfil', body, headersToken);
  }

  Future<dynamic> getContenidos(
      String idscategorias, int dias, int offset) async {
    Log.registra('getContenidos');
    return await _get(
        '/data/getContenidos?idscategorias=$idscategorias&dias=$dias&offset=$offset',
        headersToken);
  }

  Future<dynamic> getStoriesUsuario(
      String idUsuario, String idscategorias, int dias, int offset) async {
    Log.registra('getStoriesUsuario: $idUsuario');
    return await _get(
        '/data/getStoriesUsuario?idUsuario=$idUsuario&idscategorias=$idscategorias&dias=$dias&offset=$offset',
        headersToken);
  }

  Future<dynamic> setGusta(String json) async {
    Log.registra('setGusta');
    return await _post('/data/setGusta', json, headersToken);
  }

  Future<dynamic> guardarContenido(String json) async {
    Log.registra('guardarContenido');
    return await _post('/data/guardarContenido', json, headersToken);
  }

  Future<dynamic> desconectar() async {
    Log.registra('servie desconectar');
    return await _post('/data/desconectar', '', headersToken);
  }

  Future<dynamic> getStories(int dias, String categorias) async {
    Log.registra('getStories: $dias $categorias');
    return await _get(
        '/data/getStories?dias=$dias&categorias=$categorias', headersToken);
  }

  Future<dynamic> eliminarContenido(String token) async {
    Log.registra('eliminarContenido');
    return await _delete('/data/eliminarContenido', token, headersToken);
  }

  Future<dynamic> getContenidoCompartido(String idContenido) async {
    Log.registra('getContenidoCompartido');
    return await _get(
        '/data/getContenidoCompartido?idContenido=$idContenido', headers);
  }

  Future<dynamic> getVersion() async {
    Log.registra('getVersion');
    return await _get('/data/version', headers);
  }

  Future denunciarContenido(String body) async {
    Log.registra('denuncia contenido');
    await _post('/data/DenunciarContenido', body, headersToken);
  }

  Future bajaUsuario() async {
    Log.registra('baja usuario');
    await _post('/data/baja', '', headersToken);
  }

  Future validarApple(String code) async {
    Log.registra('validar Apple: $code');
    final url = Uri.parse('https://appleid.apple.com/auth/token');
    final header = <String, String>{
      'content-type': 'application/x-www-form-urlencoded',
    };
    final body = <String, String>{
      'client_id': 'es.helpncare.app',
      'client_secret': JwtToken.clientSecretApple(),
      'code': code,
      'grant_type': 'authorization_code',
    };
    try {
      final response = await _httpClient.post(url, body: body, headers: header);
      Log.registra("_post: $response");
      Log.registra("status: ${response.statusCode}");
      Log.registra("body: ${response.body}");
      //Log.registra(json.encode(response));
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
  }
}
