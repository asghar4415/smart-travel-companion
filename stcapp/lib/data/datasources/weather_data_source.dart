import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherDataSource {
  final http.Client client;
  static const String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  WeatherDataSource({required this.client});

  /// Fetch current weather for a location using latitude and longitude
  /// Returns WeatherModel or throws exception
  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final params = {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'temperature_2m,wind_speed_10m,relative_humidity_2m,weather_code',
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: params);

      final response = await client
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Weather API request timeout');
            },
          );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return WeatherModel.fromJson(json);
      } else {
        throw Exception('Failed to fetch weather: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
