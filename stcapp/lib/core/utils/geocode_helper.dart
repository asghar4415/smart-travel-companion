import 'dart:convert';

import 'package:http/http.dart' as http;

/// Geocoding helper to get latitude and longitude for a place name.
/// Uses Open-Meteo's geocoding API and caches successful lookups in memory.
class GeocodeHelper {
  static const String _baseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static final http.Client _client = http.Client();
  static final Map<String, Coordinates> _cache = {};

  /// Get coordinates for a place name.
  /// Returns coordinates or null if the lookup fails or no result is found.
  static Future<Coordinates?> getCoordinates(String placeName) async {
    final normalizedName = _normalize(placeName);
    if (_cache.containsKey(normalizedName)) {
      return _cache[normalizedName];
    }

    try {
      final uri = Uri.parse(_baseUrl).replace(
        queryParameters: {
          'name': placeName,
          'count': '1',
          'language': 'en',
          'format': 'json',
        },
      );

      final response = await _client
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Geocoding API request timeout');
            },
          );

      if (response.statusCode != 200) {
        return null;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final results = json['results'];

      if (results is List && results.isNotEmpty) {
        final firstResult = results.first;
        if (firstResult is Map<String, dynamic>) {
          final latitude = firstResult['latitude'];
          final longitude = firstResult['longitude'];

          if (latitude is num && longitude is num) {
            final coordinates = Coordinates(
              latitude.toDouble(),
              longitude.toDouble(),
            );
            _cache[normalizedName] = coordinates;
            return coordinates;
          }
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static String _normalize(String placeName) {
    return placeName.trim().toLowerCase();
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude);

  @override
  String toString() => 'Coordinates(lat: $latitude, lon: $longitude)';
}
