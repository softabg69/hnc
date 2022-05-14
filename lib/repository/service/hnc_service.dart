import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  dynamic _response(http.Response response) {
    Log.registra("response status: ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        Log.registra("json: $responseJson");
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
    return await _get('/data/politica', null);
  }

  Future<dynamic> autenticar(String token) async {
    Log.registra("autenticar: $token");
    return await _post('/data/autenticar', token, headers);
  }

  Future<dynamic> iniciarGoogle(String token) async {
    Log.registra("autenticar: $token");
    return await _post('/data/iniciarGoogle', token, headers);
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

  Future<dynamic> setGusta(String json) async {
    Log.registra('setGusta');
    return await _post('/data/setGusta', json, headersToken);
  }

  Future<dynamic> guardarContenido(String json) async {
    Log.registra('guardarContenido');
    return await _post('/data/guardarContenido', json, headersToken);
  }
}
