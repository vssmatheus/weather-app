import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:weather/api_keys.dart';

class WeatherApi {
  final String apiKey = ApiKeys.openWeatherMapKey;
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<dynamic> getWeatherByCity({String cityName = 'Rio Verde'}) async {
    final uri = Uri.parse('$baseUrl?q=$cityName&appid=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Erro ao obter dados da API');
    }
  }
}
