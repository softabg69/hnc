import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../components/configuracion.dart';
import 'custom_exceptions.dart';

class HncService {
  HncService({
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final Client _httpClient;
  String _token = '';

  void setToken(String token) {
    print("setToken: $token");
    _token = token;
  }

  void clearToken() {
    _token = '';
  }

  Uri _getUrl(String url) {
    print("URL: ${Environment().config!.baseUrlServicios}$url");
    return Uri.parse('${Environment().config!.baseUrlServicios}$url');
  }

  Future<dynamic> _get(String url) async {
    print("get: $url");
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
      print("_post: $response");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No hay conexión a internet');
    }
    return responseJson;
  }

  dynamic _response(http.Response response) {
    print("response status: ${response.statusCode}");
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        print("json: $responseJson");
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
    print("autenticar: $token");
    return await _post('/data/autenticar', token, headers);
  }

  Future<dynamic> iniciarGoogle(String token) async {
    print("autenticar: $token");
    return await _post('/data/iniciarGoogle', token, headers);
  }

  // Future<dynamic> autenticar(String email, String pwd) async {
  //   print("autenticar2: $email,$pwd");
  //   final token = JwtToken.generarToken(email, pwd, 'local', 'autenticar');
  //   print("token: $token");
  //   //print("token: $token");
  //   final response = await _httpClient.post(_getUrl('data/autenticar'),
  //       headers: {
  //         'Content-type': 'application/json',
  //         'Accept': 'application/json'
  //       },
  //       body: json.encode({'token': token}));
  //   print("status: ${response.statusCode}");
  //   if (response.statusCode == 200) {
  //     if (response.body.isNotEmpty) {
  //       return response.body;
  //     } else {
  //       throw ErrorEmptyResponse();
  //     }
  //   } else {
  //     throw ErrorGettingData('Error al autenticar usuario');
  //   }
  // }

  // final response = await _httpClient.get(
  //   getUrl(url: 'stories', extraParameters: <String, String>{
  //     'categorias': jsonEncode(categorias)
  //   }),
  // );
  // if (response.statusCode == 200) {
  //   if (response.body.isNotEmpty) {
  //     return List<Contenido>.from(
  //       json.decode(response.body).map((data) => Contenido.fromJson(data)),
  //     );
  //   } else {
  //     throw ErrorEmptyResponse();
  //   }
  // } else {
  //   throw ErrorGettingData('Error recuperando Stories');
  // }

}
