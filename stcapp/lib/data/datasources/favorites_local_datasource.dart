import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/place_model.dart';

abstract class FavoritesLocalDataSource {
  Future<void> saveFavorite(PlaceModel place);
  Future<void> removeFavorite(String placeTitle);
  Future<List<PlaceModel>> getAllFavorites();
  Future<bool> isFavorite(String placeTitle);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String _favoritesKey = 'favorites';
  final SharedPreferences sharedPreferences;

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveFavorite(PlaceModel place) async {
    try {
      final favorites = await getAllFavorites();

      // Check if place is already in favorites
      final index = favorites.indexWhere((p) => p.title == place.title);
      if (index == -1) {
        favorites.add(place);
        await _saveFavorites(favorites);
      }
    } catch (e) {
      throw Exception('Failed to save favorite: $e');
    }
  }

  @override
  Future<void> removeFavorite(String placeTitle) async {
    try {
      final favorites = await getAllFavorites();
      favorites.removeWhere((p) => p.title == placeTitle);
      await _saveFavorites(favorites);
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  @override
  Future<List<PlaceModel>> getAllFavorites() async {
    try {
      final jsonString = sharedPreferences.getString(_favoritesKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map(
            (json) => PlaceModel.fromJson(
              json as Map<String, dynamic>,
              json['location'] as String? ?? 'Unknown',
              latitude: json['latitude'] as double?,
              longitude: json['longitude'] as double?,
            ).copyWith(isFavorite: true), // Mark as favorite
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  @override
  Future<bool> isFavorite(String placeTitle) async {
    try {
      final favorites = await getAllFavorites();
      return favorites.any((p) => p.title == placeTitle);
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveFavorites(List<PlaceModel> favorites) async {
    final jsonList = favorites
        .map(
          (place) => {
            'title': place.title,
            'location': place.location,
            'description': place.description,
            'thumbnail': place.thumbnailUrl,
            'flight_price': place.flightPrice,
            'extracted_flight_price': place.extractedFlightPrice,
            'hotel_price': place.hotelPrice,
            'extracted_hotel_price': place.extractedHotelPrice,
            'link': place.link,
            'latitude': place.latitude,
            'longitude': place.longitude,
          },
        )
        .toList();

    final jsonString = jsonEncode(jsonList);
    await sharedPreferences.setString(_favoritesKey, jsonString);
  }
}
