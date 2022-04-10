import 'dart:async';
import 'dart:convert';
import '../models/contenido.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/error_exceptions.dart';

class HncService {
  HncService({
    http.Client? httpClient,
    this.baseUrl = 'https://api.rawg.io/api',
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final Client _httpClient;

  Uri getUrl({
    required String url,
    Map<String, String>? extraParameters,
  }) {
    final queryParameters = <String, String>{
      'key': dotenv.get('GAMES_API_KEY')
    };
    if (extraParameters != null) {
      queryParameters.addAll(extraParameters);
    }

    return Uri.parse('$baseUrl/$url').replace(
      queryParameters: queryParameters,
    );
  }

  Future<List<Contenido>> getStories(List<int> categorias) async {
    final response = await _httpClient.get(
      getUrl(url: 'stories', extraParameters: <String, String>{
        'categorias': jsonEncode(categorias)
      }),
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return List<Contenido>.from(
          json.decode(response.body).map((data) => Contenido.fromJson(data)),
        );
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingData('Error recuperando Stories');
    }
  }

  Map parameters = <String, String>{
    'content-type': 'application/json',
    'accept': 'application/json',
    //'authorization': 'Bearer $token'
  };
}
