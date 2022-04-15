import 'dart:async';
import 'dart:convert';
//import '../models/contenido.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/error_exceptions.dart';
import '../../components/jwt_token.dart';

class HncService {
  HncService({
    http.Client? httpClient,
    //this.baseUrl = 'https://api.rawg.io/api',
  }) : _httpClient = httpClient ?? http.Client();

  final Client _httpClient;
  String token = '';

  void setToken(String token) {
    this.token = token;
  }

  Uri getUrl(String url) {
    return Uri.parse('${dotenv.get('BASE_URL_SERVICIOS')}$url');
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

  Map<String, String> get headers => <String, String>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': 'Bearer $token'
      };

  Future<String> politica() async {
    final response = await _httpClient.get(
      getUrl('politica'),
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        return data['politica'];
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingData('Error recuperando Stories');
    }
  }

  Future<String> autenticar(String email, String pwd) async {
    print("autenticar2: $email,$pwd");
    final token = JwtToken.generarToken(email, pwd, 'local', 'autenticar');
    print("token: $token");
    //print("token: $token");
    final response = await _httpClient.post(getUrl('data/autenticar'),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: json.encode({'token': token}));
    print("status: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return response.body;
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingData('Error al autenticar usuario');
    }
  }

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
