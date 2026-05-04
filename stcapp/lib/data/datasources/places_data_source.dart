import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/places_response_model.dart';
import '../../core/constants/app_constants.dart';

abstract class PlacesDataSource {
  Future<PlacesResponseModel> getPlaces(String location);
}

class PlacesDataSourceImpl implements PlacesDataSource {
  final http.Client client;

  PlacesDataSourceImpl({required this.client});

  @override
  Future<PlacesResponseModel> getPlaces(String location) async {
    try {
      // Using proxy server for CORS support on web
      final queryParams = {'location': location};

      final uri = Uri.parse(
        AppConstants.apiBaseUrl,
      ).replace(queryParameters: queryParams);

      final response = await client
          .get(uri)
          .timeout(Duration(seconds: AppConstants.apiTimeout));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
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
}
