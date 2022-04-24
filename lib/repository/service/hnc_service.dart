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
    Log.registra("setToken: $token");
    _token = token;
  }

  void clearToken() {
    _token = '';
  }

  Uri _getUrl(String url) {
    Log.registra("URL: ${Environment().config!.baseUrlServicios}$url");
    return Uri.parse('${Environment().config!.baseUrlServicios}$url');
  }

  Future<dynamic> _get(String url) async {
    Log.registra("get: $url");
    dynamic responseJson;
    try {
      final response = await _httpClient.get(_getUrl(url));
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
    return await _get('/data/politica');
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
}
