import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/places_response_model.dart';
import '../../core/constants/app_constants.dart';

abstract class PlacesDataSource {
  Future<PlacesResponseModel> getPlaces(String location);
  Future<PlacesResponseModel> getCachedPlaces(String location);
}

class PlacesDataSourceImpl implements PlacesDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;

  PlacesDataSourceImpl({required this.client, required this.sharedPreferences});

  String _cacheKey(String location) =>
      'cached_places_${location.toLowerCase().replaceAll(' ', '_')}';

  @override
  Future<PlacesResponseModel> getPlaces(String location) async {
    try {
      // Build SerpAPI query. For web, calling SerpAPI directly may trigger
      // CORS errors in the browser; mobile platforms do not enforce CORS.
      final query = '$location Destinations';

      final uri = Uri.parse(AppConstants.apiBaseUrl).replace(
        queryParameters: {
          'engine': 'google',
          'q': query,
          'api_key': AppConstants.apiKey,
        },
      );

      if (kIsWeb) {
        // On web we avoid crashing; surface a clear error so UI can show
        // instructions to run a proxy. The app is expected to call SerpAPI
        // directly on Android/iOS where CORS isn't enforced.
        throw Exception(
          'CORS: direct SerpAPI calls are blocked in browsers. Run a proxy for web builds.',
        );
      }

      final response = await client
          .get(uri)
          .timeout(Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        await sharedPreferences.setString(_cacheKey(location), response.body);
        return PlacesResponseModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load places. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching places from API: $e');
      rethrow;
    }
  }

  @override
  Future<PlacesResponseModel> getCachedPlaces(String location) async {
    final cachedJson = sharedPreferences.getString(_cacheKey(location));

    if (cachedJson == null || cachedJson.isEmpty) {
      throw Exception('No cached places available for $location');
    }

    final jsonData = json.decode(cachedJson) as Map<String, dynamic>;
    return PlacesResponseModel.fromJson(jsonData);
  }
}
